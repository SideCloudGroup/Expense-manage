<?php

use think\migration\Migrator;

class AddPartyCurrencies extends Migrator
{
    public function up(): void
    {
        // 为party表添加货币相关字段
        $table = $this->table('party');
        $table->addColumn('base_currency', 'string', ['limit' => 10, 'null' => false, 'default' => 'cny'])
            ->addColumn('supported_currencies', 'text', ['null' => true, 'comment' => '支持的货币列表，JSON格式'])
            ->update();
    }
}
