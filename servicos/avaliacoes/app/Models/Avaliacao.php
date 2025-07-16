<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Avaliacao extends Model
{
    public $timestamps = true;
    protected $table = 'avaliacoes';

    protected $fillable = [
        'metodo_id',
        'nome',
        'email',
        'nota',
        'tags_positivas',
        'tags_negativas',
        'comentario',
    ];

    protected $casts = [
        'tags_positivas' => 'array',
        'tags_negativas' => 'array',
    ];
}