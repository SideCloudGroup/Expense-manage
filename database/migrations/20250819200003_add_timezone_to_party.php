<?php

use think\migration\Migrator;

class AddTimezoneToParty extends Migrator
{
    public function up()
    {
        $table = $this->table('party');
        $table->addColumn('timezone', 'string', [
            'limit' => 50,
            'null' => false,
            'default' => 'Asia/Shanghai',
            'comment' => '派对时区'
        ])
        ->update();
    }

    public function down()
    {
        $table = $this->table('party');
        $table->removeColumn('timezone')
        ->update();
    }
}
