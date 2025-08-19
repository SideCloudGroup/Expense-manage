<?php

use think\migration\Migrator;

class CreatePartyTables extends Migrator
{
    public function up(): void
    {
        // 创建party表
        $table = $this->table('party', ['engine' => 'InnoDB', 'collation' => 'utf8mb4_unicode_ci']);
        $table->addColumn('name', 'string', ['limit' => 128, 'null' => false])
            ->addColumn('description', 'text', ['null' => true])
            ->addColumn('invite_code', 'string', ['limit' => 32, 'null' => false])
            ->addColumn('owner_id', 'integer', ['null' => false])
            ->addColumn('created_at', 'datetime', ['null' => false, 'default' => 'CURRENT_TIMESTAMP'])
            ->addColumn('updated_at', 'datetime', ['null' => false, 'default' => 'CURRENT_TIMESTAMP', 'update' => 'CURRENT_TIMESTAMP'])
            ->addIndex(['invite_code'], ['unique' => true])
            ->addIndex(['owner_id'])
            ->create();

        // 创建party_member表
        $table = $this->table('party_member', ['engine' => 'InnoDB', 'collation' => 'utf8mb4_unicode_ci']);
        $table->addColumn('party_id', 'integer', ['null' => false])
            ->addColumn('user_id', 'integer', ['null' => false])
            ->addColumn('joined_at', 'datetime', ['null' => false, 'default' => 'CURRENT_TIMESTAMP'])
            ->addIndex(['party_id', 'user_id'], ['unique' => true])
            ->addIndex(['party_id'])
            ->addIndex(['user_id'])
            ->create();

        // 为item表添加party_id字段
        $table = $this->table('item');
        $table->addColumn('party_id', 'integer', ['null' => true, 'default' => null])
            ->addIndex(['party_id'])
            ->update();
    }
}
