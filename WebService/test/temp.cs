using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace test
{
    class temp
    {
            public int id { get; set; }
            public DateTime d { get; set; }
            public temp(int i, DateTime dt)
            {
                id = i;
                d = dt;
            }
  
    }

    class Waste
    {

        //Class represents entire database of waste usage across all users
        //Primary key includes userid and timestamp
        
        public int UserId { get; set; }
    
        public DateTime Timestamp { get; set; }
        public int Weight { get; set; }

        public Waste(int uID, DateTime timestamp, int w)
        {
            UserId = uID;
            Timestamp = timestamp;
            Weight = w;
        }
    }
}
