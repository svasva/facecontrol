require 'digest/md5'
require 'uri'
require 'open-uri'
require 'net/http'
# == VKONTAKTE API
# based on VkApiNode from	Michael Elovskih <wronglink@gmail.com> 

class VkApiNode
		# Конструктор класса. Принимает обязательные $api_id (Id приложения) и
		# $secret (секретный код приложения). 
		# 
		# @param	integer	$api_id		Id приложения.
		# @param	string	$secret		Секретный код приложения.
		# @param	string	$format		Формат ответа (XML или JSON). По умолчанию, 'XML'.
		# @param	string	$version	Версия API. По умолчанию, '2.0'.
		# @param	string	$server_url	Адрес сервера API. По умолчанию 'http://api.vkontakte.ru/api.php?'.
		# @param	mixed	$timestamp	Timestamp сервера. Если не задано - берется системное.
		# @param	mixed	$random		Случайное значение. Если не задано - задается через rand().
		def initialize(api_id,
									 secret, 
									 format = 'XML',
									 version = '2.0',
									 server_url = 'http://api.vkontakte.ru/api.php',
									 timestamp = false,
									 random = false)
									 @params={}
									 @params[:api_id] = api_id
									 #@params[:method] = method
	 							   @params[:secret] = secret
									 @params[:format] = format
									 @params[:version] = version
									 @params[:server_url] = server_url
									 @params[:timestamp] = timestamp || Time.now().to_i.to_s
									 @params[:random] = random || rand(9999999).to_s
		end

		def self.test
			r=self.new("2293668","zRcU2Rm1S15YgM4HBLFM")
			#r=self.new("2295452","NwdT5wUmJ9rpivNpWBDS")
			#r.getAppBalance()
			#r.isAppUser("4398984")
			#r.postWall("4398984","Test msg")
			r.withdrawVotes("4398984","1")#
		end
		def self.get(url)
			puts "PARSE:"+url
			uri = URI.parse(url)

			#res = Net::HTTP.start(url.host, url.port) {|http|
		#		http.get(url.path)
		#	}
		#	res.body
			uri.read
		end
	# Отправляет уведомления пользователям. Для того, чтобы пользователь получил уведомление
	# необходимо, чтобы у него было разрешено получение уведомлений в настройках.
	# @see	http://vkontakte.ru/pages.php?o=-1&p=secure.sendNotification	
	# 
	# @param	mixed	uids		Id пользователей (массив до 100 чисел или число).
	# @param	string	message	Текст сообщения.
	#
	# @return  string	Строка запроса.	
	public 
	def sendNotification(uids, message)
		api = VkApi.new('secure.sendNotification',@params)
		api.addParameter('uids', uids.join(","))
		api.addParameter('message', message)
		return api.to_s()
	end
	def postWall(uid, message)
		api = VkApi.new('wall.post',@params)
		api.addParameter('uid', uid)
		api.addParameter('status', message)
		return api.to_s()
	end
	# Возвращает платежный баланс приложения.
	# @see	http://vkontakte.ru/pages.php?o=-1&p=secure.getAppBalance
	#
	# @return  string	Строка запроса.	
	def getAppBalance()
		api = VkApi.new('secure.getAppBalance',@params)
		api.to_s()
	end
	# Возвращает установлено ли приложения.
	#
	# @return  string	Строка запроса.	
	def isAppUser(uid)
		api = VkApi.new('isAppUser',@params)
		api.addParameter('uid', uid)
		return api.to_s()
	end

	# Сохраняет строку статуса приложения для последующего вывода в
	# общем списке приложений на странице пользоваетеля.
	# @see	http://vkontakte.ru/pages.php?o=-1&p=secure.saveAppStatus
	# 
	# @param	integer	$uid	Id пользователя.
	# @param	string	$status	Текст статуса. Строка до 32 символов.
	#
	# @return  string	Строка запроса.	
	def saveAppStatus(uid, status)
		api = VkApi.new('secure.saveAppStatus',@params)
		api.addParameter('uid', uid)
		api.addParameter('status', status)
		return api.to_s()
	end
	# Возвращает баланс пользователя на счету приложения.
	# @see	http://vkontakte.ru/pages.php?o=-1&p=secure.getBalance
	# 
	# @param	integer	$uid	Id пользователя.
	#
	# @return  string	Строка запроса.	
	def getBalance(uid)
		api = VkApi.new('secure.getBalance',@params)
		api.addParameter('uid', uid)
		return api.to_s()
	end
	# Переводит голоса со счета приложения на счет пользователя.
	# @see	http://vkontakte.ru/pages.php?o=-1&p=secure.addVotes
	# 
	# @param	integer	$uid	Id пользователя.
	# @param	integer	$votes	Количество голосов (в 100 долях).
	#
	# @return  string	Строка запроса.	
	def addVotes(uid, votes)
		api = VkApi.new('secure.addVotes',@params)
		api.addParameter('uid', uid)
		api.addParameter('votes', votes)
		return api.to_s()
	end

	def addRating(uid,amount,msg)
		api = VkApi.new('secure.addRating',@params)
		api.addParameter('uid', uid)
		api.addParameter('rate', amount)
		api.addParameter('message',msg)
		return api.to_s()
	end
	
	# Списывает голоса со счета пользователя на счет приложения.
	# @see	http://vkontakte.ru/pages.php?o=-1&p=secure.withdrawVotes
	# 
	# @param	integer	$uid	Id пользователя.
	# @param	integer	$votes	Количество голосов (в 100 долях).
	#
	# @return  string	Строка запроса.	
	def withdrawVotes(uid, votes)
		api = VkApi.new('secure.withdrawVotes',@params)
		api.addParameter('uid', uid)
		api.addParameter('votes', votes)
		return api.to_s()
	end
	# Переводит голоса со счета одного пользователя на счет другого в рамках приложения.
	# @see	http://vkontakte.ru/pages.php?o=-1&p=secure.transferVotes
	# 
	# @param	integer	$uid_from	Id пользователя, от которого переводятся голоса.
	# @param	integer	$uid_to		Id пользователя, которому переводятся голоса.
	# @param	integer	$votes		Количество голосов (в 100 долях).
	# 
	# @return  string	Строка запроса.	
	def transferVotes(uid_from, uid_to, votes)
		api = VkApi.new('secure.transferVotes',@params)
		api.addParameter('uid_from', uid_from)
		api.addParameter('uid_to', uid_to)
		api.addParameter('votes', votes)
		return api.to_s()
	end
	# Возвращает историю транзакций внутри приложения.
	# @see	http://vkontakte.ru/pages.php?o=-1&p=secure.getTransactionsHistory
	# 
	# @param	integer	$type	Тип возвращаемых транзакций. 
	# 0 – все транзакции, 1 – транзакции типа "пользователь > приложение",
	# 2 – транзакции типа "приложение > пользователь", 3 – транзакции типа "пользователь > пользователь" 
	# @param	integer	$uid_from	Фильтр по Id пользователя, с баланса которого снимались голоса.
	# @param	integer	$uid_to		Фильтр по Id пользователя, на баланс которого начислялись голоса.
	# @param	integer	$date_from	Фильтр по дате начала. Задается в виде UNIX-time.
	# @param	integer	$date_to	фильтр по дате конца. Задается в виде UNIX-time.
	# @param	integer	$limit		Количество возвращаемых записей. По умолчанию 1000.
	#
	# @return  string	Строка запроса.	
	def getTransactionsHistory (type = 0, uid_from = nil, uid_to = nil, date_from = nil, date_to = nil, limit = 1000)
		api = VkApi.new('secure.getTransactionsHistory',@params)
		api.addParameter('type',type)
		api.addParameter('uid_from',uid_from) if uid_from
		api.addParameter('uid_to',uid_to) if uid_to
		api.addParameter('date_from',date_from) if date_from
		api.addParameter('date_to',date_to) if date_to
		api.addParameter('limit',limit) if limit
		return api.to_s()
	end
end

#==
# Класс VkApi. Для каждого запроса создается экземпляр данного класса,
# задаются метод API и параметры запроса и вызывается getQuery метод.  
#
# based on Michael Elovskih <wronglink@gmail.com> VkApiclass
class VkApi
	
	 # Конструктор класса.
	 # 
	 # @param	integer	api_id		Id приложения.
	 # @param	string	method		Название метода API.
	 # @param	string	secret		Секретный код приложения.
	 # @param	string	format		Формат ответа (XML или JSON).
	 # @param	string	version	Версия API.
	 # @param	string	server_url	Адрес сервера API.
	 # @param	mixed	timestamp	Timestamp сервера.
	 # @param	mixed	random		Случайное значение.
	def initialize (method,params)
		@config=params
		@params=[]
		@params << {'name' => 'api_id','value' => @config[:api_id]}
		@params << {'name' => 'method','value' => method}
		@params << {'name' => 'format','value' => @config[:format]}
		@params << {'name' => 'v','value' => @config[:version]}
		@params << {'name' => 'timestamp', 'value' => @config[:timestamp]}
		@params << {'name' => 'random', 'value' => @config[:random]}
		@server_url=@config[:server_url]
		@secret=@config[:secret]
	end


	 # __toString метод класса.
	 #
	 # @return  string	Строка запроса.	
	public 
	def to_s()
		ps=@params.sort {|x,y| x['name'] <=> y['name']} 
		ps << {'name' => 'sig', 'value' => self.getSig()}
		q=[]
		ps.each do |p|
			q<<p['name']+'='+URI.escape(p['value']||'')
		end
		return @server_url+"?"+q.join('&')
	end


	 # Добавляет параметр запроса.
	 # 
	 # @param	string	$p_name		Название параметра
	 # @param	string	$p_value	Значение параметра
	def addParameter(p_name, p_value)
		@params <<   {'name' => p_name, 'value' => p_value}
	end
	
	# Считает Sig-подпись приложения.
	# 
	# @return	string	Sig-подпись приложения.
	public 
	def getSig()
		ps=@params.sort {|x,y| x['name'] <=> y['name']} 
		ss=''
		ps.each do |k|
			if k['name']!='secret'
				ss+=k['name']+'='+(k['value']||'')
			end
		end
		sss=Digest::MD5.hexdigest(ss+@secret)
		puts "SIGN: #{ss} -> #{sss}"
		return sss
	end
end
