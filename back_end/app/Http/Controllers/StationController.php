<?php

namespace App\Http\Controllers;
use App\Http\Controllers\Auth\BaseController as BaseController;
use Illuminate\Http\Request;
use App\Models\Station;

class StationController extends BaseController
{
    public function index()
    {
        $stations = Station::all();
        return $this->sendResponse($stations, 'Stations retrieved successfully.');
    }

    //---------------------  Create Station---------------------//
    public function store(Request $request)
    {
                $request->validate([
                    'name'      => 'required',
                    'location'     => 'required',
                    'longitude'  => 'required',
                    'latitude'  => 'required',

                ]);

                $station = Station::create([
                    'name'      => $request->name,
                    'location'     => $request->location,
                    'longitude'  => $request->longitude,
                    'latitude'     => $request->latitude,
                ]);
                return $this->sendResponse($station, 'Station added.');
                
    }
    //------ show Station -----//
    public function show($id)
    {
        $station = Station::find($id);

        if (is_null($station)) {
            return $this->sendError('Station not found.');
        }

        return $this->sendResponse($station, 'Station retrieved successfully.');
    }
   //----- search by name -----//
   public function search($name)
    {
        $response = response()->json(Station::where("name", "like", "%" . $name . "%")->get());
        return $response;
    }


   //------update Station -----//
   public function update(Request $request, $id)
   {

       $station = Station::find($id);
       if ($station){
           $station->update($request->all());
           return response()->json(['message'=>'Station updated !'],200);
       }
       else {
           return response()->json(['message'=>' No Station Found to updated ! '],404);
       }

   }

   //------ delete Station-----//
   public function destroy($id)
   {

       $station = Station::find($id);
       if ($station){
           $station->delete();
           return response()->json(['message'=>'Station deleted !'],200);
       }
       else {
           return response()->json(['message'=>' No Station Found '],404);
       }

   }
}
