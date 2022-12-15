require 'selenium-webdriver'
require_relative 'aposta_provider.rb'
require_relative 'get_link_async.rb'


driver = Selenium::WebDriver.for :chrome

begin
    # Navigate to URL
    driver.get 'https://www.betburger.com/users/sign_in'

    sleep 1

    input = driver.find_element(name: 'betburger_user[email]').send_keys 'valdirmdico@hotmail.com'
    password = driver.find_element(name: 'betburger_user[password]').send_keys 'Dico240966!', :return
    # incluir o email e senha depois :return para que o enter seja pressionado
    sleep 5

    driver.get 'https://www.betburger.com/arbs'

    sleep 5

    count = 0

    ul = driver.find_element(class: 'arbs-list') # encontrar a lista de apostas
    li = ul.find_elements(tag_name: 'li') # encontrar os itens da lista de aposta

    li.each { |l|  # para cada item da lista de aposta
        l.click # clicar no item

        sleep 5

        calculator = driver.find_elements(class: 'calculator-row') # encontrar a lista de calculadoras
        # puts "calculator: #{calculator}"

        sleep 1

        count = 1

        aposta1 = {} # criar um hash para guardar as informações da aposta
        aposta2 = {} # criar um hash para guardar as informações da aposta

        calculator.each { |p| # para cada calculadora da lista pegar o titulo, link e odds

            title = p.find_element(tag_name: 'a').attribute('title')
            odd = p.find_element(class: 'with-commission-value').text

            link = p.find_element(tag_name: 'a').attribute('href') # pegar link da aposta no betburger

            sleep 5

            link_certo = GETAsync(link) # pegar o link da aposta no site correto
            puts link_certo


            if count == 1
                aposta1 = {title: title, link: link_certo, odd: odd}
            elsif count == 2
                aposta2 = {title: title, link: link_certo, odd: odd}
            end

            sleep 4
            p "numero de apostas #{count}"

            count += 1
        }
        #get_link_aposta(aposta1, aposta2)

        count = 1

        sleep 5

    }

    sleep 10000

ensure
    driver.quit
end
