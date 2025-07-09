<?php

namespace Database\Seeders;

use App\Models\Metodo;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class MetodoSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Metodo::create([
            'titulo' => 'Scrum',
            'descricao' => 'Método ágil interativo e incremental.',
            'folder' => 'scrum'
        ]);

        Metodo::create([
            'titulo' => 'Extreme Programming (XP)',
            'descricao' => 'Extreme Programming é uma metodologia ágil que enfatiza a programação em par.',
            'folder' => 'xp'
        ]);

        Metodo::create([
            'titulo' => 'Lorem Ipsum',
            'descricao' => 'Lorem Ipsum é um texto fictício usado na indústria gráfica e de impressão.',
            'folder' => 'lorem'
        ]);

        Metodo::create([
            'titulo' => 'Lorem Ipsum',
            'descricao' => 'Lorem Ipsum é um texto fictício usado na indústria gráfica e de impressão.',
            'folder' => 'lorem'
        ]);
    }
}
