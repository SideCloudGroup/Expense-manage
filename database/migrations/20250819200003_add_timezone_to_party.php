<?php

use think\migration\Migrator;

class AddTimezoneToParty extends Migrator
{
    public function up(): void
    {
        $table = $this->table('party');
        $table->addColumn('timezone', 'string', [
            'limit' => 50,
            'null' => false,
            'default' => 'Asia/Shanghai',
        ])
            ->update();
    }
}
