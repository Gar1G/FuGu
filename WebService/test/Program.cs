using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RestSharp;

namespace test
{
    class Program
    {
        static void Main(string[] args)
        {
            string s = "2017-06-06 23:59 PM";
            

            DateTime d = DateTime.ParseExact(s, "yyyy-MM-dd HH:mm tt", null);
            Waste w = new Waste(1, d, 50);
            
            //temp testingVar = new temp(2, d);


            var client = new RestClient("http://localhost:26249/");

            var request = new RestRequest("postWaste", Method.POST);
            request.AddJsonBody(w);
            request.AddHeader("Content-Type", "application/json");

            IRestResponse response = client.Execute(request);
            var content = response.Content;


            Console.Write(content);

            Console.Write("Ending New User Profile Example\r\n");

            






        }
    }
}
