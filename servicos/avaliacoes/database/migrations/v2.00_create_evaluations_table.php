<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('avaliacoes', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('metodo_id');
            $table->string('nome');
            $table->string('email', 125);
            $table->tinyInteger('nota');
            $table->json('tags_positivas')->nullable(); 
            $table->json('tags_negativas')->nullable(); 
            $table->text('comentario')->nullable();
            $table->timestamps();

            $table->foreign('email')->references('email')->on('usuarios')->onDelete('cascade');
            $table->foreign('metodo_id')->references('id')->on('metodos')->onDelete('cascade');

            $table->unique(['email', 'metodo_id']);

        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('avaliacoes');
    }
};
