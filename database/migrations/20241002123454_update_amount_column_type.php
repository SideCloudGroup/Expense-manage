<?php

use think\migration\Migrator;

class UpdateAmountColumnType extends Migrator
{
    public function change()
    {
        $table = $this->table('item');
        $table->changeColumn('amount', 'decimal', ['precision' => 10, 'scale' => 2, 'null' => false, 'default' => 0.00])
            ->update();
    }
}