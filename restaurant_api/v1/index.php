<?php

require_once '../include/Strings.php';
require_once '../include/DbHandler.php';
require_once '../include/PassHash.php';
require_once '../include/Config.php';
require '.././libs/Slim/Slim.php';
require_once '.././payU/lib/PayU.php';



\Slim\Slim::registerAutoloader();

$app = new \Slim\Slim();


Environment::setPaymentsCustomUrl("https://sandbox.api.payulatam.com/payments-api/4.0/service.cgi"); 
Environment::setReportsCustomUrl("https://sandbox.api.payulatam.com/reports-api/4.0/service.cgi"); 
Environment::setSubscriptionsCustomUrl("https://sandbox.api.payulatam.com/payments-api/rest/v4.3/"); 


// User id from db - Global Variable
global $user_id;
$user_id = NULL;

/**
 * Adding Middle Layer to authenticate every request
 * Checking if the request has a valid api key in the 'Authorization' header
 */
function authenticate(\Slim\Route $route) {
    // Getting request headers
    $headers = apache_request_headers();
    $response = array();
    $app = \Slim\Slim::getInstance();

    // Verifying Authorization Header
    if (isset($headers['authorization'])) {
        $db = new DbHandler();

        // get the api key
        $api_key = $headers['authorization'];
       // validating api key
        if (!$db->isValidApiKey($api_key)) {
            // api key is not present in users table
            $response["error"] = true;
            $response["message"] = "Access Denied. Invalid Api key";
            echoRespnse(401, $response);
            $app->stop();
        } else {
            global $user_id;
            // get user primary key id
            $user_id = $db->getUserId($api_key);
        }
    } else {
        // api key is missing in header
        $response["error"] = true;
        $response["message"] = "Api key is missing";
        echoRespnse(400, $response);
        $app->stop();
    }
}

/**
* 
*
*
**/
/**
 * ----------- METHODS WITHOUT AUTHENTICATION ---------------------------------
 */
/**
 * User Registration
 * url - /register
 * method - POST
 * params - first name,last name, email, user key, user type
 */
$app->post('/register', function() use ($app) {
            // check for required params
            verifyRequiredParams(array('user_key','username','email','user_type'));

            $response = array();
             

          //   $gcm = new GCM();
            // reading post params
            $username = $app->request->post('username');
           
            $user_key =$app->request->post('user_key');
            
            $email = $app->request->post('email');
			
            $user_type = $app->request->post('user_type');
          
            
          
            // validating email address
           // validateEmail($email);

            $db = new DbHandler();
            $res = $db->createUser($user_key,$username,$email,$user_type);
            
        if ($res == USER_CREATED_SUCCESSFULLY) 

         {

          $user = $db->getUserByEmail($email);
            if($user)
            {

               if($user["user_type"] == CUSTOMER)
			   {
				   $result = $db->insertCustomer($user["id"]);
			   }
			   else if($user["user_type"] == EMPLOYEE)
			   {
				   $result = $db->insertEmployees($user["id"]);
			   }
			   else if($user["user_type"] == ADMINISTRATOR)
			   {
				   $result = $db->insertAdministrators($user["id"]);
			   }
			   
                $response["error"] = false;
               $response["message"] = "WELCOME To Foody ". $username;
                $response["user_id"] = $user["id"];
                $response["user_key"] = $user_key;
               
                $response["username"] = $user["name"];
              
           
                $response["email"] = $user["email"];
                $response["api_key"] = $user["api_key"];
                $response["user_type"] = $user["user_type"];
				
                 $response["created_at"] = $user["created_at"];


     }
     else
     {

      $response["error"] = true;
                
                 $response["message"] = "User Registered, but unable to retrieve user details";

     }

             

            } else if ($res == USER_CREATE_FAILED) {
                $response["error"] = true;
                $response["message"] = "Oops! An error occurred while registering";
            } else if ($res== USER_ALREADY_EXIST) {
 $update_user_key = $db->updateUser($user_key,$username);
              $user = $db->getUserByEmail($email);
              if($user)
              {
                $response["error"] = false;
                $response["message"] = "Welcome back ".$username;
                $response["user_id"] = $user["id"];
                $response["user_key"] = $user["user_key"];
                $response["user_name"] = $user["name"];
             
                $response["email"] = $user["email"];
           
                $response["api_key"] = $user["api_key"];
                $response["user_type"] = $user["user_type"];
               // $response["created_at"] = $user["created_at"];
                $response["updated_on"] = $user["updated_on"];
                
              }
                
            }else if($res == USER_BLOCKED_BY_SYSTEM)
            {
              $response["error"] = true;
                $response["message"] = $first_name." ". $last_name. '! you have been blocked from accessing this app, please contact the service administrator';
            }


             
            // echo json response
            echoRespnse(201, $response);
        });




/*
 *
 *
 * ------------------------ METHODS WITH AUTHENTICATION ------------------------
 */


/**
* Insert user details into user_info table
* @name
* @quote
* @location
**/
$app->post('/users/:user_id/profile','authenticate', function($user_id) use ($app) {
 
  //   global $user_id;
     $db = new DbHandler();
    
	
  // check for required params
            verifyRequiredParams(array('country','address','city','age','longitude','latitude','phone'));

            $response = array();
             
          //   $gcm = new GCM();
            // reading post params
            $country = $app->request->post('country');
            $address = $app->request->post('address');
            $phone = $app->request->post('phone');
            $city = $app->request->post('city');
            $age =$app->request->post('age');
            
            $longitude = $app->request->post('longitude');
			
            $latitude = $app->request->post('latitude');
          
            $db = new DbHandler();
			if($db->doesUserInfoExists($user_id))
			{
				$res = $db->updateUserInfo($user_id,$country,$address,$city,$age,$longitude,$latitude,$phone);
				if($res != null)
			{
         $response["error"] = false;
         $response["updated"] = true;
         $response["message"] = "Successfully Updated";
                 // echo json response
            echoRespnse(201, $response);
			}
			else
			{
         $response["error"] = true;
         $response["false"] = true;
                $response["message"] = "UnSuccessfully Updated";
                 // echo json response
            echoRespnse(200, $response);
			
			}
			}
			else
			{
            $res = $db->insertUserInfo($user_id,$country,$address,$city,$age,$longitude,$latitude,$phone);
			if($res)
			{
         $response["error"] = false;
         $response["updated"] = true;
                $response["message"] = "Successful";
                 // echo json response
            echoRespnse(201, $response);
			}
			else
			{
         $response["error"] = true;
         $response["false"] = true;
         $response["message"] = "UnSuccessful";
                 // echo json response
            echoRespnse(200, $response);
			
			}
			}
  



  });


/**
* Add to cart
* @user_id
* @item_id
* @quantity
**/
$app->post('/food/items/:item_id/addToCart','authenticate', function($item_id) use ($app) {
 
  global $user_id;
  $db = new DbHandler();
 

// check for required params
         verifyRequiredParams(array('quantity','price'));

         $response = array();
          
       //   $gcm = new GCM();
         // reading post params
         $quantity = $app->request->post('quantity');
         $price = $app->request->post('price');
          $total = $quantity * $price;
       
         $db = new DbHandler();
         if($db->isAlreadyInCart($user_id,$item_id))
         {
           $result = $db->updateItemQuantityInCart($user_id,$item_id,$quantity,$price,$total);
           if($result != null)
           {
            $response['error'] = false;
            $response['messages'] = "Item Quantity updated successfully";
            echoRespnse(200, $response);
           }
           else
           {
            $response['error'] = true;
            $response['messages'] = "Failed to update Item Quantity";
            echoRespnse(200, $response);
           }
         }
         else{
           $result = $db->addToCart($user_id,$item_id,$quantity,$price,$total);

           if($result != null)
           {
            $response['error'] = false;
            $response['messages'] = "Item successfully added to Cart";
            echoRespnse(200, $response);

           }
           else{

            $response['error'] = true;
            $response['messages'] = "An error occured while adding item to cart";
            echoRespnse(200, $response);
           }

         }
        });


/**
 * Insert feedback
 */
$app->post('/users/:user_id/feeback', 'authenticate', function($user_id) use($app){
  global $user_id;
  $response = array();
              $db = new DbHandler();
              // check for required params
              verifyRequiredParams(array('feedback','order_id'));
  
  
               $feedback=$app->request->post('feedback');
               $order_id=$app->request->post('order_id');
              
   
    $res = $db->insertFeedback($user_id,$feedback,$order_id);
              
  
     if($res != null)
     {
     
                  $response["error"] = false;
                
                  $response["message"] = "Feedback Added Successfully";
                  
                  echoRespnse(201, $response);
              
                    }
                    else
                    {
                  $response["error"] = true;
                
                  $response["message"] = "Unable to add Feedback";
                  
                  echoRespnse(200, $response);
                    }
               
  
              
  
      });
      



    
 

  
  
  
  /**
   * Listing all items from the shop 
   * 
   */ 
    $app->get('/food/items/:offset', function($offset)
    {
      global $user_id;
        $response = array();
       
        $db=new DbHandler();
           // getting server ip address

 $id = $db->getHighestItemId();
        //fetching all post
       if($offset == 0)
       {
       
          $offset = $id["id"];
       }
       else
       {
        $offset = $offset-1;

       }

       
        $result = $db->getAllItems($offset);
        $rows = $result->num_rows;
      
        $response["items"] = array();
     
        //looping through result and preparing post array
        for($j=$offset; $j < $offset+20 && $j < $offset + $rows; $j++)
        {
          $item = $result->fetch_assoc();
         $tmp = array();
        
          //  $tmp["rows"] = $rows;
            $tmp["id"] = $item["id"];
            $tmp["category"] = $item["category"];
            $tmp["price"] = $item["price"];
            $tmp["name"] = $item["name"];
            $tmp["image_url"] = 'http://' . SERVER_IP . '/' . 'restaurant/v1/food' . '/' .$item["image_url"];

         
       
            array_push($response["items"], $tmp);
        
       
       }
        
       
       
      
          echoRespnse(200, $response);
       
       

       

});



 /**
   * Listing all items from the shop 
   * 
   */ 
  $app->get('/food/extras', function()
  {
    global $user_id;
      $response = array();
     
      $db=new DbHandler();
         // getting server ip address


     $offset = 0;
     
      $result = $db->getAllExtras();
      $rows = $result->num_rows;
    
      $response["extras"] = array();
   
      //looping through result and preparing post array
      for($j=$offset; $j < $offset+20 && $j < $offset + $rows; $j++)
      {
        $item = $result->fetch_assoc();
       $tmp = array();
      
        //  $tmp["rows"] = $rows;
          $tmp["id"] = $item["id"];
          $tmp["category"] = $item["category"];
          $tmp["price"] = $item["price"];
          $tmp["name"] = $item["name"];
          $tmp["image_url"] = 'http://' . SERVER_IP . '/' . 'restaurant/v1/food' . '/' .$item["image_url"];

       
     
          array_push($response["extras"], $tmp);
      
     
     }
      
     
     
    
        echoRespnse(200, $response);
     
     

     

});



 /**
   * Listing all users items from the cart
   * 
   */ 
  $app->get('/food/cart', 'authenticate', function()
  {
    global $user_id;
      $response = array();
     
      $db=new DbHandler();
         // getting server ip address


     
      $result = $db->getAllUserItemsInCart($user_id);
      $rows = $result->num_rows;
    
      $response["cart_items"] = array();
        $offset = 1000;
     
      //looping through result and preparing post array
      for($j=$offset; $j < $offset+10 && $j < $offset + $rows; $j++)
      {
        $item = $result->fetch_assoc();
       $tmp = array();
      
          $tmp["id"] = $item["id"];
          $tmp["category"] = $item["category"];
          $tmp["quantity"] = $item["quantity"];
          $tmp["name"] = $item["name"];
         $tmp["price"] = $item["price"];
          
          $tmp["image_url"] ='http://' . SERVER_IP . '/' . 'restaurant/v1/food' . '/' .$item["image_url"];

     
          array_push($response["cart_items"], $tmp);
      
     
     }
      
     
     
    
        echoRespnse(200, $response);
     
     

     

});



/**
   * Listing all categories
   * 
   */ 
  $app->get('/food/categories', function()
  {
    global $user_id;
      $response = array();
     
      $db=new DbHandler();
         // getting server ip address
        $offset = 0;

     
      $result = $db->getFoodCategories();
      $rows = $result->num_rows;
    
      $response["Categories"] = array();
   
     
      //looping through result and preparing post array
      for($j=$offset; $j < $offset+10 && $j < $offset + $rows; $j++)
      {
        $item = $result->fetch_assoc();
       $tmp = array();
      
         
          $tmp["id"] = $item["id"];
        
          $tmp["name"] = $item["name"];
         $tmp["image"] = 'http://' . SERVER_IP . '/' . 'restaurant/v1/categories' . '/' .$item["image_url"];
        
          array_push($response["Categories"], $tmp);
      
     
     }
      
     
     
    
        echoRespnse(200, $response);
     
     

     

});


/**
 * this function gets single items from database
 */
 
$app->get('/food/item/:item_id','authenticate',function($item_id) {
  global $user_id;
             $response = array();
              $db = new DbHandler();
  
  $item = $db->getSingleItem($item_id);
 if($item != null)
 {

 // $response["error"] = false;
  $response["id"] = $item["id"];
  $response["category"] = $item["category"];        
  $response["price"] = $item["price"];
 $response["name"] = $item["name"];
 
  $response["image_url"] ='http://' . SERVER_IP . '/' . 'restaurant/v1/food' . '/' .$item["image_url"];

   echoRespnse(200, $response);
 }
 else
 {
  $response["error"] = true;
  $response["message"] = "Could'nt retrieve the selected item";
  echoRespnse(200, $response);
 }
  
  });

  
/**
 * this function gets the TOTAL for a user's order 
 */
 
$app->get('/food/purchases/count','authenticate', function() {
  global $user_id;
             $response = array();
              $db = new DbHandler();
  
  $item = $db->pendingItemCount($user_id);
 if($item != null)
 {
  $response["error"] = false;
  if($item["totalItems"] == null)
  {
    $response["total"] =0;
  }
  else
  {
    $response["total"] = $item["totalItems"];
  }
 
  
   echoRespnse(200, $response);
 }
 else
 {
  $response["error"] = true;
  $response["message"] = "Could'nt retrieve the total for the items";
  echoRespnse(200, $response);
 }
  
  });

  
/**
 * this function gets the TOTAL for a user's order 
 */
 
$app->get('/items/total','authenticate', function() {
  global $user_id;
             $response = array();
              $db = new DbHandler();
  
  $item = $db->getPendingOrderTotal($user_id);
 if($item != null)
 {
  $response["error"] = false;
  $response["total"] = $item["total"];
  
   echoRespnse(200, $response);
 }
 else
 {
  $response["error"] = true;
  $response["message"] = "Could'nt retrieve the total for the items";
  echoRespnse(200, $response);
 }
  
  });


  $app->get('/order/:order_id/items/total','authenticate', function($order_id) {
    global $user_id;
               $response = array();
                $db = new DbHandler();
    
    $item = $db->getCompletedOrderTotal($user_id,$order_id);
   if($item != null)
   {
    $response["error"] = false;
    $response["total"] = $item["total"];
    
     echoRespnse(200, $response);
   }
   else
   {
    $response["error"] = true;
    $response["message"] = "Could'nt retrieve the total for the items";
    echoRespnse(200, $response);
   }
    
    });
  

/** 
 * uploading user profile image
 * method POST
 * url /users/:user_id/profileImage
 *
 **/
$app->post('/users/:user_id/profileImage', 'authenticate', function() use ($app){

  global $user_id;  
             $response = array();
             $db = new DbHandler();
 
     
       // Path to move uploaded files
             $target_path = "profilepictures/";
 
             $response = array();
         
        if (isset($_FILES['image']['name'])) {
     $target_path = $target_path . basename($_FILES['image']['name']);
        try {
         // Throws exception incase file is not being moved
         if (!move_uploaded_file($_FILES['image']['tmp_name'], $target_path)) {
             // make error flag true
             $response['error'] = true;
             $response['message'] = 'Could not move the file!';
         }
  
     } catch (Exception $e) {
         // Exception occurred. Make error flag true
         $response['error'] = true;
         $response['message'] = $e->getMessage();
     }
 } else {
     // File parameter is missing
     $response['error'] = true;
     $response['message'] = 'Not received any file!F';
 }
 // check for required params
             verifyRequiredParams(array('image'));
             $image = $app->request->post('image');
       if($db->isImageAvailable($user_id))
       {
         $image_id = $db->updateUserImage($user_id,$image);
          if($image_id != NULL)
             {
             $response["error"] = false;
 
            // $ext = pathinfo($path, PATHINFO_EXTENSION);
                 $response["message"] = " profile image updated Successfully";
                 $response["user_id"] = $user_id;
                $response["image_id"] = $image_id;
                 $response["image"] =$image;
                $response["mime"] = pathinfo($image, PATHINFO_EXTENSION);
 
                
                 echoRespnse(201, $response);
             } else {
                 $response["error"] = true;
                 $response["message"] = " profile Image Failed to update .Please try again";
                 echoRespnse(200, $response);
             }
       }
       else{
             // uploading profile picture
             $image_id = $db->insertUserProfileImage($user_id,$image);
               if($image_id != NULL)
             {
             $response["error"] = false;
 
            // $ext = pathinfo($path, PATHINFO_EXTENSION);
                 $response["message"] = " Profile Image Uploaded Successfully";
                 $response["user_id"] = $user_id;
                 $response["image_id"] = $image_id;
                 $response["image"] =$image;
                  $response["mime"] = pathinfo($image, PATHINFO_EXTENSION);
 
                
                 echoRespnse(201, $response);
             } else {
                 $response["error"] = true;
                 $response["message"] = "  Failed to upload Profile image. please try again";
                 echoRespnse(200, $response);
             }
         }
         });
 






         


/**
 * Verifying if required params were posted or not
 */
function verifyRequiredParams($required_fields) {
    $error = false;
    $error_fields = "";
    $request_params = array();
    $request_params = $_REQUEST;
    // Handling PUT request params
    if ($_SERVER['REQUEST_METHOD'] == 'PUT') {
       $app = \Slim\Slim::getInstance();
        parse_str($app->request()->getBody(), $request_params);
    }
    foreach ($required_fields as $field) {
        if (!isset($request_params[$field]) || strlen(trim($request_params[$field])) <= 0) {
            $error = true;
            $error_fields .= $field . ', ';
        }
    }

    if ($error) {
        // Required field(s) are missing or empty
        // echo error json and stop the app
        $response = array();
        $app = \Slim\Slim::getInstance();
        $response["error"] = true;
        $response["message"] = 'Required field(s) ' . substr($error_fields, 0, -2) . ' is missing or empty';
        echoRespnse(400, $response);
        $app->stop();
    }
}


/**
 * Validating email address
 */
function validateEmail($email) {
    $app = \Slim\Slim::getInstance();
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $response["error"] = true;
        $response["message"] = 'Email address is not valid';
        echoRespnse(400, $response);
        $app->stop();
    }
}

/**
 * Echoing json response to client
 * @param String $status_code Http response code
 * @param Int $response Json response
 */
function echoRespnse($status_code, $response) {
    $app = \Slim\Slim::getInstance();
    // Http response code
    $app->status($status_code);

    // setting response content type to json
    $app->contentType('application/json');

    echo json_encode($response);
}

//dummy function used to test
function echoResponse($response)
{
   $app = \Slim\Slim::getInstance();
    // setting response content type to json
    $app->contentType('application/json');

echo json_encode($response);
}


$app->run();
?>