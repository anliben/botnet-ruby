require 'selenium-webdriver'
require_relative 'get_link_async.rb'
require_relative 'database/combinacao.rb'
require_relative 'database/aposta.rb'


driver = Selenium::WebDriver.for :chrome
driver2 = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(:timeout => 30)

db_aposta = Aposta.new
db_comb = Combinacao.new

begin
  # Navigate to URL
  driver.get 'https://www.betburger.com/users/sign_in'

  sleep 1

  input = driver.find_element(name: 'betburger_user[email]').send_keys 'valdirmdico@hotmail.com'
  password = driver.find_element(name: 'betburger_user[password]').send_keys 'Dico240966!', :return
  # incluir o email e senha depois :return para que o enter seja pressionado
  sleep 3

  driver.get 'https://www.betburger.com/arbs'

  sleep 3

  ul = driver.find_element(class: 'arbs-list') # encontrar a lista de apostas
  li = ul.find_elements(tag_name: 'li') # encontrar os itens da lista de aposta
  count = 1

  li.each { |l| # para cada item da lista de aposta
    l.click # clicar no item

    sleep 3

    calculator = driver.find_elements(class: 'calculator-row') # encontrar a lista de calculadoras
    # puts "calculator: #{calculator}"

    sleep 1


    aposta1 = {} # criar um hash para guardar as informações da aposta
    aposta2 = {} # criar um hash para guardar as informações da aposta

    calculator.each { |p| # para cada calculadora da lista pegar o titulo, link e odds

      title = p.find_element(tag_name: 'a').attribute('title')
      odd = p.find_element(class: 'with-commission-value').text

      link = p.find_element(tag_name: 'a')#.attribute('href') # pegar link da aposta no betburger

      original_window = driver.window_handle # pegar a janela original
      link.click # clicar no link da aposta

      # Wait for the new window or tab
      wait.until { driver.window_handles.length == 2 }

      link_certo = ''

      #Loop through until we find a new window handle
      driver.window_handles.each do |handle|
        if handle != original_window
          driver.switch_to.window handle
          link_certo = driver.find_element(class: 'copy-content').text # clicar no botão de apostar
          sleep 1
          driver.close
          driver.switch_to.window original_window
          break
        end
      end

      sleep 2

      if count == 1
        aposta1 = db_aposta.insert(title, odd, link_certo) #{ title: title, link: link_certo, odd: odd }
      elsif count == 2
        aposta2 = db_aposta.insert(title, odd, link_certo) #{ title: title, link: link_certo, odd: odd }
      end
      puts "count: #{count}"
      sleep 5
      count += 1
    }
    puts "aposta1: #{aposta1}"
    puts "aposta2: #{aposta2}"

    db_comb.insert(aposta1, aposta2)
    count = 1
    sleep 3

  }

  sleep 10000

ensure
  driver.quit
  puts "driver quited"
end
