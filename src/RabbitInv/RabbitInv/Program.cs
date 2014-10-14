using System.Text;
using RabbitMQ.Client;
using System;


namespace RabbitInv
{
	public class Send
	{
		private static void Main(string[] args)
		{
			var _factory = new ConnectionFactory() {HostName = "localhost", UserName = "admin", Password = "admin"};
			using (var _connection = _factory.CreateConnection())
			{
				using (var _channel = _connection.CreateModel())
				{
				//
					_channel.ExchangeDeclare("NoelEx", "fanout");
					_channel.QueueDeclare("Noel1", true, false, false, null);
					_channel.QueueBind("Noel1", "NoelEx", "rx");

					var _message = "Hello Noel";
					var _body = Encoding.UTF8.GetBytes(_message);

					_channel.BasicPublish("NoelEx", "", null, _body);
				}
			}
		}
	}
}
