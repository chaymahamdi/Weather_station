<?php

namespace App\Http\Controllers;
use App\Http\Controllers\Auth\BaseController as BaseController;
use App\Models\User;
use App\Models\Station;

use Illuminate\Http\Request;

class UserController extends BaseController
{
    public function show()
   {
       $user = User::find(auth()->user()->id);
       if ($user){
           return $this->sendResponse($user, 'User retrieved successfully.');  
       }
       else{
           return $this->sendError('User not found.');
       }
   }
   public function addFavorite(Request $request)
   {
       $user = User::find(auth()->user()->id);
       $station= Station::find($request->id);
       $user->stations()->save($station);
      return $this->sendResponse(null, 'station Favorite added');    
   }
   public function Favorites()
   {   
       $liste=array();
       $user = User::find(auth()->user()->id);
       foreach ($user->stations as $station){
        array_push($liste, $station->id);
       }
      return $this->sendResponse($liste, 'stations Favorite');    
   }

}
