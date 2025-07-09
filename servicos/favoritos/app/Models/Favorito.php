<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Favorito extends Model
{
    public $timestamps = false;
    protected $table = 'favoritos';
    
    protected $fillable = [
        'email',
        'metodo_id',
    ];

}
