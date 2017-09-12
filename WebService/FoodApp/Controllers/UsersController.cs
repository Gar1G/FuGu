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
    public class UsersController : ApiController
    {
        private FoodAppContext db = new FoodAppContext();



        public class userStatus
        {
            public int login_status { get; set; } //0: Not Success, 1: Login success, 2: Register Success
            public int credential_status { get; set; } //0: Credentials fine, 1: UserID OR Password incorrect, 2: User already exists

            
        }

        [Route("RegisterUser")]
        [HttpGet]
        public IHttpActionResult registerUser(int userid, string email, string firstName, string lastName, string password)
        {
            User u = db.Users.Find(userid);
            userStatus us;

            //user id does not exist and registering
            if(u == null)
            {
                User newUser = new User { UserId = userid, Email = email, firstName = firstName, lastName = lastName, Password = password };
                db.Users.Add(newUser);
                try
                {
                    db.SaveChanges();
                }
                catch
                {
                    return BadRequest("Error registering user");
                }

                us = new userStatus { login_status = 2, credential_status = 0 };
                return Ok(us);
            }
            //if userid exists
            else if (u != null)
            {
                us = new userStatus { login_status = 0, credential_status = 2 };
                return Ok(us);
            }
            else
            {
                return BadRequest("Unknown Error");
            }
        }

        [Route("LoginUser")]
        [HttpGet]
        public IHttpActionResult loginUser(int userid, string password )
        {
            User u = db.Users.Find(userid);
            userStatus status;

            if(u == null)
            {
                status = new userStatus { login_status = 0, credential_status = 1 }; 
            }
            else
            {
                //correct password
                if(u.Password == password)
                {
                    status = new userStatus { login_status = 1, credential_status = 0 };

                }
                //incorrect password
                else
                {
                    status = new userStatus { login_status = 0, credential_status = 1 };
                }
            }
            return Ok(status);
        }


        


        // GET: api/Users
        public IQueryable<User> GetUsers()
        {
            return db.Users;
        }

        // GET: api/Users/5
        [ResponseType(typeof(User))]
        public async Task<IHttpActionResult> GetUser(int id)
        {
            User user = await db.Users.FindAsync(id);
            if (user == null)
            {
                return NotFound();
            }

            return Ok(user);
        }

        // PUT: api/Users/5
        [ResponseType(typeof(void))]
        public async Task<IHttpActionResult> PutUser(int id, User user)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != user.UserId)
            {
                return BadRequest();
            }

            db.Entry(user).State = EntityState.Modified;

            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UserExists(id))
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

        // POST: api/Users
        [ResponseType(typeof(User))]
        public async Task<IHttpActionResult> PostUser(User user)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.Users.Add(user);
            await db.SaveChangesAsync();

            return CreatedAtRoute("DefaultApi", new { id = user.UserId }, user);
        }

        // DELETE: api/Users/5
        [ResponseType(typeof(User))]
        public async Task<IHttpActionResult> DeleteUser(int id)
        {
            User user = await db.Users.FindAsync(id);
            if (user == null)
            {
                return NotFound();
            }

            db.Users.Remove(user);
            await db.SaveChangesAsync();

            return Ok(user);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool UserExists(int id)
        {
            return db.Users.Count(e => e.UserId == id) > 0;
        }
    }
}