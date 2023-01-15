<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Auth\BaseController as BaseController;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthController extends BaseController
{
    public function register(Request $request)
    {
        $fields=$request->validate(
            ['name'=>'required|string',
            'email'=>'required|string|unique:users',
            'password'=>'required|string|confirmed',
        ]);
        $user=User::create([
            'name'=>$fields['name'],
            'email'=>$fields['email'],
            'password'=>bcrypt($fields['password']),
            'is_admin' =>  0,

        ]);
        $token = $user->createToken('auth_token')->plainTextToken;

        $result=[
            'name'=>$user->name,
            'email'=>$user->email,
            'token'=>$token,
            'is_admin' =>  $user->is_admin
        ];

        return $this->sendResponse($result,"Register Done!");
    }

    public function login(Request $request)
    {
        $request->validate([
            'email'     => 'email',
            'password'  => 'required',
        ]);
        $user = User::where('email', $request['email'])->first();
        if (!$user || !Hash::check($request['password'], $user->password))

            return $this->sendError('Wrong Input');
        else {
            $token = $user->createToken('auth_token')->plainTextToken;
            $result=[
                'name'=>$user->name,
                'email'=>$user->email,
                'token'=>$token,
                'is_admin' =>  $user->is_admin
            ];
            return $this->sendResponse($result, 'User login successfully.');
        }
    }

    public function logout()
    {
        $user = Auth::user();
        $user->tokens()->delete();
        return $this->sendResponse(null, 'User loggedout successfully.');
    }
}
