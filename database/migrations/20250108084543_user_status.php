<?php

use think\migration\Migrator;

class UserStatus extends Migrator
{
    public function up()
    {
        $user = $this->table('user');
        $user->addColumn('enable', 'boolean', ['default' => 1])
            ->save();
    }
}
