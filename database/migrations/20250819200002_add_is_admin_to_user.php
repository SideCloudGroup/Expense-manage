<?php

use think\migration\Migrator;

class AddIsAdminToUser extends Migrator
{
    public function up(): void
    {
        $table = $this->table('user');
        $table->addColumn('is_admin', 'boolean', ['default' => 0])->update();
    }
}
