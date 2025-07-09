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
        Schema::create('favoritos', function (Blueprint $table) {
            $table->id();
            $table->string('email', 125);
            $table->unsignedBigInteger('metodo_id',);

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
        Schema::dropIfExists('favoritos');
    }
};
