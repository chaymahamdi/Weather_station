<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use Maatwebsite\Excel\Facades\Excel;
use InfluxDB2;
use DateTime;
use App\Exports\InfluxdbExport;
use App\Http\Controllers\Auth\BaseController as BaseController;

class InfluxDBController extends BaseController
{
    public function index(Request $request, $mesurment)
    {
        $latest=$request->latest=="true";
        $mesurments=[
            "precipitations" => "device_frmpayload_data_analoginput_0",
            "pressure" => "device_frmpayload_data_barometer_4",
            "humidity" => "device_frmpayload_data_humiditySensor_2",
            "luminosity" => "device_frmpayload_data_illuminanceSensor_1",
            "temperature" => "device_frmpayload_data_temperatureSensor_3"
        ];

        $token = 'hChb_sDWSnXG7zoLU6l-GbyMUdWmIkSsZYrGjfb9UK-INuKOv6FsTI0bcE7yEMixMJeuBugLku9uGT_kQFzxiA==';
        $org = 'SWALP';
        $bucket = 'Weather_Station_Bucket';

        $client = new InfluxDB2\Client([
            "url" => "http://52.51.92.31:8086",
            "token" => $token,
            "bucket" => $bucket,
            "org" => $org,
            "precision" => InfluxDB2\Model\WritePrecision::NS,
        ]);

        $queryApi = $client->createQueryApi();

        if($latest)
        {
            $query = "from(bucket: \"$bucket\")
            |> range(start:1640995200)
            |> last()
            |> filter(fn: (r) => r._measurement == \"$mesurments[$mesurment]\")
            ";
        }
        else
        {
            $start=$request->start;
            $stop=$request->stop;
            $query = "from(bucket: \"$bucket\")
            |> range(start:$start, stop:$stop)
            |> filter(fn: (r) => r._measurement == \"$mesurments[$mesurment]\")
            ";
        }

        $tables = $queryApi->query($query, $org);

        $records = [];
        foreach ($tables as $table) {
            foreach ($table->records as $record) {
                $dt=$record->getTime();
                $dateTime=(new DateTime($dt))->format('Y-m-d H:i:s');
                $records[$dateTime] = $record->getValue();
            }
        }
        return $this->sendResponse($records, 'Data retrieved successfully.');
    }
    public function store(Request $request)
    {
        
        $token = 'hChb_sDWSnXG7zoLU6l-GbyMUdWmIkSsZYrGjfb9UK-INuKOv6FsTI0bcE7yEMixMJeuBugLku9uGT_kQFzxiA==';
        $org = 'SWALP';
        $bucket = 'Weather_Station_Bucket';

        $client = new InfluxDB2\Client([
            "url" => "http://52.51.92.31:8086",
            "token" => $token,
            "bucket" => $bucket,
            "org" => $org,
            "precision" => InfluxDB2\Model\WritePrecision::NS,
        ]);

        $queryApi = $client->createQueryApi();

            $start=$request->start;
            $stop=$request->stop;
            $query1 = "from(bucket: \"$bucket\")
            |> range(start:$start, stop:$stop)
            |> filter(fn: (r) => r._measurement == \"device_frmpayload_data_barometer_4\")
            ";
            $query2 = "from(bucket: \"$bucket\")
            |> range(start:$start, stop:$stop)
            |> filter(fn: (r) => r._measurement == \"device_frmpayload_data_humiditySensor_2\")
            ";
            $query3 = "from(bucket: \"$bucket\")
            |> range(start:$start, stop:$stop)
            |> filter(fn: (r) => r._measurement == \"device_frmpayload_data_illuminanceSensor_1\")
            ";
            $query4 = "from(bucket: \"$bucket\")
            |> range(start:$start, stop:$stop)
            |> filter(fn: (r) => r._measurement == \"device_frmpayload_data_temperatureSensor_3\")
            ";
         $tables1 = $queryApi->query($query1, $org);
         $tables2 = $queryApi->query($query2, $org);
         $tables3 = $queryApi->query($query3, $org);
         $tables4 = $queryApi->query($query4, $org);


        $pressures = [];
        foreach ($tables1 as $table) {
            foreach ($table->records as $record) {
                $dt=$record->getTime();
                $dateTime=(new DateTime($dt))->format('Y-m-d H:i:s');
                $pressures[$dateTime] = $record->getValue();
            }
        }
        $humidity = [];
        foreach ($tables2 as $table) {
            foreach ($table->records as $record) {
                $dt=$record->getTime();
                $dateTime=(new DateTime($dt))->format('Y-m-d H:i:s');
                $humidity[$dateTime] = $record->getValue();
            }
        }
        $luminosity = [];
        foreach ($tables3 as $table) {
            foreach ($table->records as $record) {
                $dt=$record->getTime();
                $dateTime=(new DateTime($dt))->format('Y-m-d H:i:s');
                $luminosity[$dateTime] = $record->getValue();
            }
        }
        $temperatures = [];
        foreach ($tables4 as $table) {
            foreach ($table->records as $record) {
                $dt=$record->getTime();
                $dateTime=(new DateTime($dt))->format('Y-m-d H:i:s');
                $temperatures[$dateTime] = $record->getValue();
            }
        }
        $mesures=[];
        
        foreach (array_combine($pressures, $humidity) as $p => $h) {
            /*$mesure=null;
            $mesure->pressure=$p;
            $mesure->humidity=$h;*/
            $arr=array("pressure"=>$p, "humidity"=>$h);
            $mesure=(object)$arr;
            $mesures[] = $mesure;
        }
        return response()->json($mesures);
        //return $this->sendResponse($mesures, 'Data retrieved successfully.');
    }
    public function exportInfluxdb(){
        return Excel::download(new InfluxdbExport, 'data.xlsx');
    }
}
