# Weather Station 
Front_end : Flutter 
Back_end : laravel 
after cloning our project from github :
step1: verify that Xampp and composer are installed Xampp php version 8 , project laravel version 9
step2: Go to the folder application back_end : run composer install and copy .env in example where you have to change the database name (DB_DATABASE) to whatever you have in phpMyadmin (before that you have to create a database in phpMyadmin)
step3: run in the folder back_end : run "php artisan migrate --seed "
step4: run php artisan serve 
step5 : we have to run flutter so we have to get dependencies  : run dart pub get 
step6: run our app in an emulater device  created from Android Studio for example