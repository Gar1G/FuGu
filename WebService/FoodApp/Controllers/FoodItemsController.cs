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

namespace FoodApp.Controllers
{
    public class FoodItemsController : ApiController
    {
        private FoodAppContext db = new FoodAppContext();

        
        [Route("AddItems")]
        [HttpPost]
        public IHttpActionResult BulkAddItems(UserFoodList foodList)
        {
            //Adds each item to the db
            foreach(var i in foodList.FoodItems)
            {
                db.FoodItems.Add(new FoodItem(i.ProductId, foodList.UserId, i.ProductName, i.Weight, i.Price, i.Purchased, i.Expiry, i.Priority, i.Weight, true));
            }
            db.SaveChanges();
            return Ok();
        }

        

        [Route("UpdateItem")]
        [HttpPost]
        public IHttpActionResult updateItems(FoodItem item)
        {

            FoodItem f = db.FoodItems.Find(item.ProductId, item.UserId);

            if(f == null)
            {
                return NotFound();
            }
            else
            {
                f.inFridge = !f.inFridge;
            }
            return Ok();
            
        }


        [Route("RemoveItem")]
        [HttpDelete]
        public IHttpActionResult RemoveItem(int id, int userid)
        {
            FoodItem foodItem = db.FoodItems.Find(id, userid);
            if (foodItem == null)
            {
                return NotFound();
            }
            db.FoodItems.Remove(foodItem);
            db.SaveChanges();

            return Ok(foodItem);
        }

        [Route("GetItems")]
        [HttpGet]
        public IHttpActionResult GetItems(int id)
        {
            UserFoodList userList = new UserFoodList(id);

            var foodlist = from Item in db.FoodItems
                           where Item.UserId == id
                           where Item.inFridge == true
                           select Item;

            foreach(var i in foodlist)
            {
                FoodItem newItem = new FoodItem(i.ProductId, i.UserId, i.ProductName, i.Weight, i.Price, i.Purchased, i.Expiry, i.Priority, i.AmountRemaining, i.inFridge);
                userList.FoodItems.Add(newItem);
            }

            return Ok(userList);
        }




    







        // GET: api/FoodItems
        public IQueryable<FoodItem> GetFoodItems()
        {
            return db.FoodItems;
        }

        

        // GET: api/FoodItems/5
        [ResponseType(typeof(FoodItem))]
        public async Task<IHttpActionResult> GetFoodItem(int id)
        {
            FoodItem foodItem = await db.FoodItems.FindAsync(id);
            if (foodItem == null)
            {
                return NotFound();
            }

            return Ok(foodItem);
        }

        // PUT: api/FoodItems/5
        [ResponseType(typeof(void))]
        public async Task<IHttpActionResult> PutFoodItem(int id, FoodItem foodItem)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != foodItem.ProductId)
            {
                return BadRequest();
            }

            db.Entry(foodItem).State = EntityState.Modified;

            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!FoodItemExists(id))
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

        // POST: api/FoodItems
        [ResponseType(typeof(FoodItem))]
        public async Task<IHttpActionResult> PostFoodItem(FoodItem foodItem)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.FoodItems.Add(foodItem);
            await db.SaveChangesAsync();

            return CreatedAtRoute("DefaultApi", new { id = foodItem.ProductId }, foodItem);
        }

        // DELETE: api/FoodItems/5
        [ResponseType(typeof(FoodItem))]
        public async Task<IHttpActionResult> DeleteFoodItem(int id)
        {
            FoodItem foodItem = await db.FoodItems.FindAsync(id);
            if (foodItem == null)
            {
                return NotFound();
            }

            db.FoodItems.Remove(foodItem);
            await db.SaveChangesAsync();

            return Ok(foodItem);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool FoodItemExists(int id)
        {
            return db.FoodItems.Count(e => e.ProductId == id) > 0;
        }
    }
}