require 'selenium-webdriver'
require 'two_captcha'
require 'http'
require 'json'
require_relative '../database/aposta.rb'

class Navigation

  attr_accessor :aposta, :driver, :wait
  def initialize(aposta)
    @client = TwoCaptcha.new('my_captcha_key')

    @aposta = aposta
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(:timeout => 30)

    @driver.get 'https://br.1xbet.com/en' #@aposta[:link]

    sleep 1
    # clica no form de login com id curLoginForm
    @driver.find_element(id: 'curLoginForm').click
    sleep 1

    # preenche o campo de email com id auth_id_email
    @driver.find_element(id: 'auth_id_email').send_keys '534516967'
    sleep 1

    # preenche o campo de senha com id auth-form-password
    @driver.find_element(id: 'auth-form-password').send_keys '5d9as5ty', :return

    p "aguardando 20 segundos - Resolva o captcha"
    sleep 20
    p "Tempo expirou irei prosseguir"

    @driver.get @aposta[2]

    sleep 2

    types = @driver.find_element(class: 'bet_type')

    types.each do |type|
      file = File.new("types.txt", "a+")
      file.puts type.text +"\n"
    end


    # @driver.script("document.querySelector('#register_body_container > div > div:nth-child(2) > div > div:nth-child(4) > div').style.display = 'block';")

    # element_site_key = @driver.find_element(css: '#register_body_container > div > div:nth-child(2) > div > div:nth-child(4) > div')
    # site_key = element_site_key.attribute('data-sitekey')

    # response = HTTP.post("https://2captcha.com/in.php?key=16115d9dbb7ecac27270ce746f291dc7&method=userrecaptcha&googlekey=#{site_key}")

    # p response.body

    # cc = @driver.find_element(id: 'g-recaptcha-response-1').send_keys
    # p cc.text


    # actions_confirm = @driver.find_element(class: 'swal2-actions')

    # @driver.execute_script("document.getElementsByClassName('swal2-actions')[0].style.display = 'block';")

    # sleep 1

    # btn_confirm = @driver.find_element(class: 'swal2-confirm')
    # # make btn confirm visible
    # @driver.execute_script("
    # document.getElementsByClassName('swal2-confirm')[0].style.display = 'block';")
    # # click btn confirm

    # espera 3 segundos
    sleep 3000


  end
end


db_aposta = Aposta.new

aposta = db_aposta.get_aposta_by_id(1)
pp aposta[0]

nav = Navigation.new(aposta[0])
