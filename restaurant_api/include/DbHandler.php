<?php
 
/**
 * Class to handle all db operations
 * This class will have CRUD methods for All 'androiddev' database tables
 * 
 * @author Rosius Ateh Ndimofor
 * @app -----> "Sppitti => An E-commerce platform"
 */

class DbHandler {
 
    private $conn;
 
    function __construct() {
         
        require_once dirname(__FILE__) . '/DbConnect.php';
        
        // opening db connection
        $db = new DbConnect();
        $this->conn = $db->connect();
       
    }
 
    /* ------------- `users` table method ------------------ */
 
    /**
     * Creating new user in "SPPITTI".. There are 3 types of users(Customers, Employees,Administrators)
	 * @param String $user_key User firebase key
    *
     * @param String $username User full name
     * @param String $email User login email id
     * @param String $password User login password
	 * @param String &user_type  Is the user a customer || Employees || Administrator
     */
    public function createUser($user_key,$username,$email,$user_type) {
        require_once dirname(__FILE__) .'/PassHash.php';
       
        
        $response = array();
  // insert query
            global $conn;
            $userId = $this->isUserExists($email);
        // First check if user already exist in db
        if ($userId["id"] == NULL) {
            // Generating password hash
          // $password_hash = PassHash::hash($password);
 
            // Generating API key
            $api_key = $this->generateApiKey();
            
              
 
            
            $stmt = $this->conn->prepare("INSERT INTO users(user_key,name,email,api_key,user_type,status) values(?,?,?,?,?, 'active')");
            $stmt->bind_param("sssss", $user_key,$username,$email,$api_key,$user_type);
 
            $result = $stmt->execute();
 
            $stmt->close();
  
 
            // Check for successful insertion
            if ($result) {
                
                // User successfully inserted
                return USER_CREATED_SUCCESSFULLY;
            } else {
                // Failed to create user
                return USER_CREATE_FAILED;
            }
        }
        else if($userId["status"] == 'blocked')
        {
           // User successfully inserted
                return USER_BLOCKED_BY_SYSTEM;
        }
            else
            {
              
                return USER_ALREADY_EXIST;
              
              
            }
      
 
        return $response;
    }
	

    
      /**
     * Generating random Unique MD5 String for user Api key
     */
    private function generateApiKey() {
        return md5(uniqid(rand(), true));
    }
   

    /**
    ** Get User key  from user table
    *
    *
    **/
    public function getUserKey($user_id)
    {

      $stmt = $this->conn->prepare("SELECT user_key from users where id =?");
        $stmt->bind_param("i", $user_id);
         if ($stmt->execute()) {
            $user_key = $stmt->get_result()->fetch_assoc();
            $stmt->close();
            return $user_key;
        } else {
            return NULL;
        }

    }
    /**
    * When a user signs back in, this function mainly updates he's GCM_ID.
    * I do this because the GCM_ID sometimes becomes invalid, due to reasons like:
    *  App Uninstall e.t.c
    **/

    public function updateGcmIdWithEmail($gcm_id,$email)
{
    $stmt = $this->conn->prepare("UPDATE users u set u.gcm_id = ?,u.updated_at=NOW() WHERE u.email = ? ");
    $stmt->bind_param("ss", $gcm_id,$email);
        $stmt->execute();
        $num_affected_rows = $stmt->affected_rows;
        $stmt->close();
        return $num_affected_rows > 0;
}


/**
 * deleting a user profile..
 * Maybe the user is feeedddd upppppp....hahahhahahha(people be stalking that MF)
 * @param user_id
 *
 **/
 public function deleteUserProfile($user_id)
 { 
  $stmt = $this->conn->prepare("UPDATE users u set u.status='deactivated',u.deleted_at=NOW() WHERE u.id = ? ");
    $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $num_affected_rows = $stmt->affected_rows;
        $stmt->close();
        return $num_affected_rows > 0;
}



/**
* Insert FCM KEY
*
*
**/

public function insertFcmKey($user_id,$fcm_key)
{

  $stmt = $this->conn->prepare("Insert  into fcm (user_id,fcm_key) values(?,?)");
        $stmt->bind_param("is", $user_id,$fcm_key);
        $stmt->execute();
        $num_affected_rows = $stmt->affected_rows;
        $stmt->close();
        return $num_affected_rows > 0;
}

/**
* update FCM KEY
*
*
**/

public function updateFcmKey($user_id,$fcm_key)
{

  $stmt = $this->conn->prepare("UPDATE fcm f set f.fcm_key = ?,f.updated_on = Now() WHERE f.user_id = ?");
        $stmt->bind_param("si", $fcm_key,$user_id);
        $stmt->execute();
        $num_affected_rows = $stmt->affected_rows;
        $stmt->close();
        return $num_affected_rows > 0;
}





    /**
     * Checking for duplicate user by email address
     * Checking user status.
     * If user is Active, return .
     * If user is  Deactivated. Return something.
     * If User is blocked. Return something
     * @param String $email: email to check in db
     * @return boolean
     */
    public function isUserExists($email) {
        
        $stmt = $this->conn->prepare("SELECT id,status from users WHERE email = ?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $res=$stmt->get_result()->fetch_assoc();
        
          return $res;
       $stmt->close();
    
       
     
    }
    /**
     * Checking for duplicate user profile pictures
     * @return boolean
     */
    public function isImageAvailable($user_id){
        
        $stmt = $this->conn->prepare("SELECT p.id from profile_pictures p WHERE p.user_id = ?");
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $res=$stmt->get_result()->fetch_assoc();
        
          return $res;
       $stmt->close();
    
       
     
    }

      /**
     * Checking for To see if another employer has already opted to deliver the products
     * @return boolean
     */
    public function isAlreadyDelivered($user_id,$order_id){
        
        $stmt = $this->conn->prepare("SELECT d.id from deliveries d WHERE d.user_id =? and d.order_id = ? and d.status ='pending'");
        $stmt->bind_param("is",$user_id,$order_id);
        $stmt->execute();
        $res=$stmt->get_result()->fetch_assoc();
        
          return $res;
       $stmt->close();
    
       
     
    }
     /**
      *update profile picture, if it exists 
      *
      */

      public function updateUserImage($user_id,$image)
      {
        $query = "UPDATE profile_pictures p set p.profile_pic_name= ?,p.updated_on = Now() WHERE p.user_id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("si",$image,$user_id);
          $stmt->execute();
         $num_affected_rows = $stmt->affected_rows;
         $stmt->close();
         return $num_affected_rows;
      }


	 /**
     * Checking if user has already updated his personal info
     */
    public function doesUserInfoExists($user_id) {
        
        $stmt = $this->conn->prepare("SELECT id from users_info WHERE user_id = ?");
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $res=$stmt->get_result()->fetch_assoc();
        
          return $res;
       $stmt->close();
    
       
     
    }
    	 /**
     * Checking if user has already updated his personal info
     */
    public function getUsersTable($user_id) {
        
        $stmt = $this->conn->prepare("SELECT id,user_key,first_name,last_name,email,user_type from users WHERE id = ? and status ='active' OR status='updated'");
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $res=$stmt->get_result()->fetch_assoc();
        
          return $res;
       $stmt->close();
    
       
     
    }
	
		 /**
     * Checking if user already has an FCM key available
     */
    public function doesUserFCMKeyExist($user_id) {
        
        $stmt = $this->conn->prepare("SELECT id from fcm WHERE user_id = ?");
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $res=$stmt->get_result()->fetch_assoc();
        
          return $res;
       $stmt->close();
    
       
     
    }

    /**
     * this function checks to see if item with same id is already in CART
     * 
     * 
     */
    public function isAlreadyInCart($user_id,$item_id) {
        
        $stmt = $this->conn->prepare("SELECT id from purchases WHERE user_id = ? and item_id= ? and status ='pending'");
        $stmt->bind_param("ii", $user_id,$item_id);
        $stmt->execute();
        $res=$stmt->get_result()->fetch_assoc();
        
          return $res;
       $stmt->close();
    }

     /**
	*
	* Update Users Table, change user_type
	*
	**/
	public function updateUsersTable($user_id)
	{
       
		$query = "UPDATE users u set u.status = 'inactive',u.updated_on = Now() WHERE u.id = ?";
		
		 $stmt = $this->conn->prepare($query);
         $stmt->bind_param("i",$user_id);
 
            $stmt->execute();
 
            $num_affected_rows = $stmt->affected_rows;
            $stmt->close();
  
 
            // Check for successful insertion
            if ($num_affected_rows>0) {
				return $num_affected_rows;
			}
			else{
				
				return NULL;
			}
    
    }
    

	
	/**
	*
	* get user profile information
	*
	**/
	
		public function getCompleteUserInformation($user_id)
	{
		$query = "SELECT u.id,u.user_key,u.first_name,u.last_name,u.email,u.api_key,u.user_type, ui.country,ui.address,ui.city,ui.age,ui.longitude,ui.latitude,ui.phone,p.profile_pic_name from users u
		 LEFT JOIN users_info ui on u.id = ui.user_id
         LEFT JOIN profile_pictures p on u.id = p.user_id
          WHERE u.id = ? and u.status = 'active'";
		 $stmt = $this->conn->prepare($query);
		  $stmt->bind_param("i", $user_id);
        if ($stmt->execute()) {
            $user = $stmt->get_result()->fetch_assoc();
            $stmt->close();
            return $user;
        } else {
            return NULL;
        }
    }
    
    /**
     *  add item to shopping cart(add item to purchases table with status='pending')
     * 
     * 
     */
    public function addToCart($user_id,$item_id,$quantity,$price,$total)
    {
        $query = "INSERT into purchases(user_id,item_id,quantity,price,total,status) VALUES (?,?,?,?,?,'pending')";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("iiiii",$user_id,$item_id,$quantity,$price,$total);
         $result = $stmt->execute();
         if($result != null)
         {
             return $result;
            
         }
         else
         {
             return NULL;
         }

        

    }


     /**
     *  add Order_id and User_id to deliveries 
     * 
     * 
     */
    public function addToDeliveries($user_id,$order_id)
    {
        $query = "INSERT into deliveries(user_id,order_id,status) VALUES (?,?,'pending')";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("is",$user_id,$order_id);
         $result = $stmt->execute();
         if($result != null)
         {
             return $result;
            
         }
         else
         {
             return NULL;
         }

        

    }

    
 
    /**
     *  This function deletes items from Cart, but it's just an update function which 
     *  changes the status of the item from pending to deleted
     * 
     */
    public function deleteItemFromCart($user_id,$item_id)
    {
       
        $query = "UPDATE purchases p set p.status= 'deleted',p.updated_at = Now() WHERE p.user_id = ? and p.item_id =?";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("ii",$user_id,$item_id);
         $result = $stmt->execute();
         $num_affected_rows = $stmt->affected_rows;
         $stmt->close();
         return $num_affected_rows;


    }

    /**
     *  this function gets all items in cart for a particular user
     * 
     * 
     */

     public function getAllUserItemsInCart($user_id)
     {
        $query="SELECT i.id,i.category,i.name,i.price,i.image_url,p.quantity from food_items i LEFT JOIN purchases p on p.item_id = i.id where p.user_id = ? and p.status = 'pending'";
        $stmt = $this->conn->prepare($query);
         $stmt->bind_param("i",$user_id);
         $stmt->execute();
         $items=$stmt->get_result();
 
         $stmt->close();
         return $items;
        }

        

   /**
     *  this function gets Order numbers for completed Items
     * 
     * 
     */

    public function getCompletedOrderId($user_id)
    {
       $query="SELECT DISTINCT p.order_id,p.user_id from purchases p  where p.user_id = ? and p.status = 'completed'";
       $stmt = $this->conn->prepare($query);
        $stmt->bind_param("i",$user_id);
        $stmt->execute();
        $items=$stmt->get_result();

        $stmt->close();
        return $items;
       }




    /**
     *  this function gets all items for invoicing
     * 
     * 
     */

     public function getItemsInCartForInvoicing($user_id)
     {
        $query="SELECT i.id,i.categoria,i.cod,i.description,i.image_url,i.valores,i.other0,i.other1,i.other2,i.other3,
         i.other4,i.other5,p.quantity from items i LEFT JOIN purchases p on p.item_id = i.id where p.user_id = ? and p.status = 'pending'";
        $stmt = $this->conn->prepare($query);
         $stmt->bind_param("i",$user_id);
         $stmt->execute();
         $items=$stmt->get_result();
 
         $stmt->close();
         return $items;
        }

    
    
    
     /**
     * 
     * @param type $offset
     * @return type
     * Fetching All Items from the items table in page format(10)
     */
    public function getAllItems($offset)
     {
       $query ="SELECT i.id,i.category,i.name,i.price,i.image_url,i.created_at from food_items i
       WHERE i.id <= ? ORDER By i.id DESC LIMIT 20 ";
 
          $stmt = $this->conn->prepare($query);
        $stmt->bind_param("i",$offset);
        $stmt->execute();
        $items=$stmt->get_result();

        $stmt->close();
        return $items;

    }
    /**
     * 
     * 
     * @return type
     * Fetching All Extras
     */
    public function getAllExtras()
     {
       $query ="SELECT i.id,i.category,i.name,i.price,i.image_url,i.created_at from food_extras i
       WHERE i.id >0 ORDER By i.id DESC LIMIT 20 ";
 
          $stmt = $this->conn->prepare($query);
       
        $stmt->execute();
        $items=$stmt->get_result();

        $stmt->close();
        return $items;

    }

     /**
     * 
     * @param type $offset
     * @return category
     * Fetching All Items per category from the items table in page format(10)
     */
    public function getAllItemsPerCategory($offset,$category)
     {
       $query ="SELECT i.id,i.categoria,i.cod,i.description,i.valores,i.image_url,i.other0,i.other1,i.other2,i.other3,i.other4,i.other5, sc.name from items i
      join shop_categories sc on i.categoria= sc.id WHERE i.id <= ? and i.categoria = ? ORDER By i.id DESC LIMIT 10 ";
 
          $stmt = $this->conn->prepare($query);
        $stmt->bind_param("ii",$offset,$category);
        $stmt->execute();
        $items=$stmt->get_result();

        $stmt->close();
        return $items;

    }

      /**
     *  Function to upload user profile picture
     *   @param user_id
     *   @param image
     */
    public function insertUserProfileImage($user_id,$image)
    {
        $stmt=$this->conn->prepare("INSERT into profile_pictures(user_id,profile_pic_name) VALUES (?,?)");
        $stmt->bind_param("is",$user_id,$image);
        $res = $stmt->execute();
         $stmt->close();
         if($res)
         {
            //Image inserted successfully
          return $new_image_id= $this->conn->insert_id;
           
            //

         }
         else
         {
            return NULL;
         }
    }

    /**
     *  Function Leave a feedback
     *   @param user_id
     *   @param image
     */
    public function insertFeedback($user_id,$feedback,$order_id)
    {
        $stmt=$this->conn->prepare("INSERT into feedback(user_id,feedback,order_id) VALUES (?,?,?)");
        $stmt->bind_param("iss",$user_id,$feedback,$order_id);
        $res = $stmt->execute();
         $stmt->close();
         if($res)
         {
            //Image inserted successfully
          return $res;
         
         }
         else
         {
            return NULL;
         }
    }


    
     /**
     * 
     * 
     * @return type list
     * Fetching All Categories from shop categories table
     */
    public function getFoodCategories()
     {
       $query ="SELECT id,name,image_url from categories";
 
          $stmt = $this->conn->prepare($query);
       
        $stmt->execute();
        $items=$stmt->get_result();

        $stmt->close();
        return $items;

    }

      /**
    * get single post.
    *  @param user_id,post_id
    *
    **/

    public function getSingleItem($item_id)
    {
     $stmt = $this->conn->prepare("SELECT i.id,i.category,i.name,i.price,i.image_url,i.created_at from food_items i
     WHERE i.id = ?");
     $stmt->bind_param("i",$item_id);
     $res = $stmt->execute();
     if($res != null)
     {
        $post = $stmt->get_result()->fetch_assoc();
        return $post;
     }
     else
     {
        return NULL;
     }
   }
	
    /**
    * just get the user name and profile picture of user
    *
    *
    **/

    public function getUserNameAndImage($user_key)
    {
 $stmt = $this->conn->prepare("SELECT u.name,i.image_name from users u
  left join user_profile_images i on u.id = i.user_id where u.user_key = ?");

             $stmt->bind_param("s", $user_key);
        if ($stmt->execute()) {
            $user = $stmt->get_result()->fetch_assoc();
            $stmt->close();
            return $user;
        } else {
            return NULL;
        }
    }
	

     /**
    * just get the user name and profile picture of user
    *
    *
    **/

    public function getUserName($user_id)
    {
 $stmt = $this->conn->prepare("SELECT name,user_key,i.image_name from users u
  left join user_profile_images i on u.id = i.user_id where u.id = ?");

             $stmt->bind_param("i", $user_id);
        if ($stmt->execute()) {
            $user = $stmt->get_result()->fetch_assoc();
            $stmt->close();
            return $user;
        } else {
            return NULL;
        }
    }
     /**
    *  get GCM_id of a user you want to follow
    *
    *
    **/

    public function getGcmId($user_id)
    {
 $stmt = $this->conn->prepare("SELECT fcm_key from fcm u where u.user_id = ?");

             $stmt->bind_param("i", $user_id);
        if ($stmt->execute()) {
            $user = $stmt->get_result()->fetch_assoc();
            $stmt->close();
            return $user;
        } else {
            return NULL;
        }
    }

/**
    ** Update user table , if user already exists
    */
        public function updateUser($user_key,$username) {
  
        $stmt = $this->conn->prepare("UPDATE users u set u.name = ?, u.updated_on = Now() WHERE u.user_key = ? ");
          $stmt->bind_param("ss",$username,$user_key);
 
            $result = $stmt->execute();
 
            $stmt->close();
 
            // Check for successful update
            if ($result) {
                return $result;
            }
            else
            {
                return null;
            }
        }

/**
    *  get GCM_id of a user you want to follow
    *
    *
    **/

    public function getGcmWithUserKey($user_key)
    {
 $stmt = $this->conn->prepare("SELECT  gcm_id from users u where u.user_key = ?");

             $stmt->bind_param("s", $user_key);
        if ($stmt->execute()) {
            $user = $stmt->get_result()->fetch_assoc();
            $stmt->close();
            return $user;
        } else {
            return NULL;
        }
    }

	

    
    /**
     * Checking user login
     * @param String $email User login email id
     * @param String $password User login password
     * @return boolean User login status success/fail
     */
    public function checkLogin($email, $password) {
        // fetching user by email
        $stmt = $this->conn->prepare("SELECT password_hash FROM users WHERE email = ?");
 
        $stmt->bind_param("s", $email);
 
        $stmt->execute();
 
        $stmt->bind_result($password_hash);
 
        $stmt->store_result();
 
        if ($stmt->num_rows > 0) {
            // Found user with the email
            // Now verify the password
 
            $stmt->fetch();
 
            $stmt->close();
 
            if (PassHash::check_password($password_hash, $password)) {
                // User password is correct
                return TRUE;
            } else {
                // user password is incorrect
                return FALSE;
            }
        } else {
            $stmt->close();
 
            // user does not exist with given email
            return FALSE;
        }
    }
 
    
 
    /**
     * Fetching user by email
     * @param String $email User email id
     */
    public function getUserByEmail($email) {
        $stmt = $this->conn->prepare("SELECT id,user_key,name,email, api_key,user_type,status, created_on,updated_on FROM users WHERE email = ?");
        $stmt->bind_param("s", $email);
        if ($stmt->execute()) {
            $user = $stmt->get_result()->fetch_assoc();
            $stmt->close();
            return $user;
        } else {
            return NULL;
        }
    }
   /**
     * Fetching user information by id
     *  $user_id here represents the id of the follower.
     * I use it to determine if this user($user_id) is following 
     *
     **/
    public function viewUserProfile($user_id,$up_id) {
        $stmt = $this->conn->prepare("SELECT u.id as user_id,u.api_key AS api_key, u.name, u.quote,u.location,u.gender, upi.image_name,ucp.image_name as coverPic,
         (SELECT count(post) from posts where posts.user_id=u.id AND (posts.status = 'created' OR posts.status = 'updated')) as toriCount, 
         (SELECT count(follower) from follow_user where follow_user.following =u.id) as followers, 
         (SELECT count(following) from follow_user where follow_user.follower =u.id) as following,
          (SELECT f.following from follow_user f where f.follower=? AND u.id = f.following) as followerId,
          (SELECT id from block where blocked_by = ? AND blocked_user_id = ?) as blockedId
        
          from users u 
            LEFT JOIN user_profile_images upi on u.id = upi.user_id 
            LEFT JOIN user_cover_pic ucp on u.id = ucp.user_id
            where u.id =?");
        $stmt->bind_param("iiii",$user_id,$user_id,$up_id,$up_id);
        if ($stmt->execute()) {
            $user = $stmt->get_result()->fetch_assoc();
            $stmt->close();
            return $user;
        } else {
            return NULL;
        }
    }

    /**
    * fetch all user details
    * name,email,proifle pic, cover pic
    *
    **/

   public function getCompleteUserProfile($user_id) {
        $stmt = $this->conn->prepare("SELECT u.id as user_id,u.api_key AS api_key, u.name, u.quote,u.location,u.gender, upi.image_name as profile_pic,ucp.image_name as coverPic
         
          from users u 
            LEFT JOIN user_profile_images upi on u.id = upi.user_id 
            LEFT JOIN user_cover_pic ucp on u.id = ucp.user_id
            where u.id =? ");
        $stmt->bind_param("i",$user_id);
        if ($stmt->execute()) {
            $user = $stmt->get_result()->fetch_assoc();
            $stmt->close();
            return $user;
        } else {
            return NULL;
        }
    }
 
    /**
     * Fetching user api key
     * @param String $user_id user id primary key in user table
     */
    public function getApiKeyById($user_id) {
        $stmt = $this->conn->prepare("SELECT api_key FROM users WHERE id = ?");
        $stmt->bind_param("i", $user_id);
        if ($stmt->execute()) {
            $api_key = $stmt->get_result()->fetch_assoc();
            $stmt->close();
            return $api_key;
        } else {
            return NULL;
        }
    }
 
    /**
     * Validating user api key
     * If the api key is there in db and the user's status is active, it is a valid key
     * @param String $api_key user api key
     * @return boolean
     */
    public function isValidApiKey($api_key) {
        $stmt = $this->conn->prepare("SELECT id from users WHERE api_key = ? AND status = 'active' OR status = 'updated'");
        $stmt->bind_param("s", $api_key);
        $stmt->execute();
        $stmt->store_result();
        $num_rows = $stmt->num_rows;
        $stmt->close();
        return $num_rows > 0;
    }



/**
 * get last post id
 *
 **/
 public function getHighestItemId()
{
    $stmt = $this->conn->prepare("SELECT id from food_items order by id DESC limit 1");
    $stmt->execute();
            $results = $stmt->get_result()->fetch_assoc();
            $stmt->close();
            return $results;
          }

          
/**
 * get last pending delivery id
 *
 **/
 public function getHighestDeliveryId()
 {
     $stmt = $this->conn->prepare("SELECT id from deliveries order by id DESC limit 1");
     $stmt->execute();
             $results = $stmt->get_result()->fetch_assoc();
             $stmt->close();
             return $results;
           }




/**
* this function Searches for users in user table
*
*
*/

 public function searchUser($name)
 {
    $stmt = $this->conn->prepare("SELECT u.id,i.image_name,u.user_key,u.name from users u  left join user_profile_images i on u.id = i.user_id where u.name LIKE ?");

     // $param = '%'$name'%';
    $stmt->bind_param('s',$name);
   if ($stmt->execute()) {
            $result = $stmt->get_result();
            $stmt->close();
            return $result;
        } else {
            return NULL;
        }

    

 }






}


    
