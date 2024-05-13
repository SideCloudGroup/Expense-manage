<?php

use think\migration\Migrator;

class Init extends Migrator
{
    public function up()
    {
        $table = $this->table('user', ['engine' => 'InnoDB', 'collation' => 'utf8mb4_unicode_ci']);
        $table->addColumn('username', 'string', ['limit' => 128, 'null' => false])
            ->addColumn('password', 'string', ['limit' => 128, 'null' => false])
            ->create();
        $table = $this->table('item', ['engine' => 'InnoDB', 'collation' => 'utf8mb4_unicode_ci']);
        $table->addColumn('userid', 'integer', ['null' => false])
            ->addColumn('description', 'string', ['limit' => 255, 'null' => false])
            ->addColumn('created_at', 'datetime',['null'=>false, 'default'=>'CURRENT_TIMESTAMP'])
            ->addColumn('amount', 'double', ['null'=>false, 'default'=>0.00, 'precision'=>10, 'scale'=>2])
            ->addColumn('paid', 'boolean', ['null'=>false, 'default'=>false])
            ->addColumn('initiator', 'integer', ['null'=>false])
            ->create();
    }
}
