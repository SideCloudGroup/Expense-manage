<?php

use think\migration\Migrator;
use think\migration\db\Column;

class AddIsAdminToUser extends Migrator
{
    public function up(): void
    {
        $table = $this->table('user');
        
        // 添加is_admin字段，默认为0（非管理员）
        $table->addColumn('is_admin', 'boolean', [
            'default' => 0,
            'comment' => '是否为管理员：0=否，1=是'
        ])->update();
    }
}
