using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using FoodApp.Models;
using Newtonsoft.Json;

namespace FoodApp.Controllers
{
    public class WastesController : ApiController
    {
        private FoodAppContext db = new FoodAppContext();

        //Working
        [Route("postWaste")]
        [HttpPost]
        public IHttpActionResult postWaste(Waste w)
        {
           
            int id = w.UserId;
            DateTime d = w.Timestamp;
            Waste entry = db.Wastes.Find(d, id);
            

            if(entry == null)
            {
                db.Wastes.Add(w);
                db.SaveChanges();
                return Ok();
            }
            else
            {
                return BadRequest("Entry already exists");
            }
            
        }

       
        //working
        [Route("getWaste")]
        [HttpGet]
        public IHttpActionResult getWaste(int id, int days)
        {
            DateTime today = DateTime.Today;
            TimeSpan t = new TimeSpan(days, 0, 0, 0);
            DateTime d = today.Subtract(t);




            List<Waste> list = new List<Waste>();

            //Returns all waste entries between now and this moment 1 week ago
            var wasteList = from entry in db.Wastes
                            where entry.UserId == id && entry.Timestamp >= d
                            select entry;
             
            foreach (var i in wasteList)
            {
                Waste newEntry = new Waste(i.UserId, i.Timestamp, i.Weight);
                list.Add(newEntry);
            }

            return Ok(list);
        }




        // GET: api/Wastes
        public IQueryable<Waste> GetWastes()
        {
            return db.Wastes;
        }

        // GET: api/Wastes/5
        [ResponseType(typeof(Waste))]
        public async Task<IHttpActionResult> GetWaste(DateTime id)
        {
            Waste waste = await db.Wastes.FindAsync(id);
            if (waste == null)
            {
                return NotFound();
            }

            return Ok(waste);
        }
        
        // PUT: api/Wastes/5
        [ResponseType(typeof(void))]
        public async Task<IHttpActionResult> PutWaste(DateTime id, Waste waste)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != waste.Timestamp)
            {
                return BadRequest();
            }

            db.Entry(waste).State = EntityState.Modified;

            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!WasteExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return StatusCode(HttpStatusCode.NoContent);
        }
    

        // DELETE: api/Wastes/5
        [ResponseType(typeof(Waste))]
        public async Task<IHttpActionResult> DeleteWaste(DateTime id)
        {
            Waste waste = await db.Wastes.FindAsync(id);
            if (waste == null)
            {
                return NotFound();
            }

            db.Wastes.Remove(waste);
            await db.SaveChangesAsync();

            return Ok(waste);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool WasteExists(DateTime id)
        {
            return db.Wastes.Count(e => e.Timestamp == id) > 0;
        }
    }
}