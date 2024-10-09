<?php

use Ramsey\Uuid\Uuid;
use think\migration\Migrator;

class MfaSupport extends Migrator
{
    public function change()
    {
        $mfa = $this->table('mfa_credential', ['id' => 'id', 'comment' => 'MFA Credentials']);
        $mfa->addColumn('userid', 'integer', ['limit' => 11, 'null' => false, 'comment' => '用户ID'])
            ->addColumn('body', 'text', ['null' => false, 'comment' => '密钥内容'])
            ->addColumn('name', 'string', ['limit' => 255, 'null' => true, 'default' => null, 'comment' => '设备名称'])
            ->addColumn('rawid', 'string', ['limit' => 255, 'null' => true, 'default' => null, 'comment' => '设备ID'])
            ->addColumn('created_at', 'datetime', ['null' => false, 'default' => 'CURRENT_TIMESTAMP', 'comment' => '创建时间'])
            ->addColumn('used_at', 'datetime', ['null' => true, 'default' => null, 'comment' => '上次使用时间'])
            ->addColumn('type', 'string', ['limit' => 255, 'null' => false, 'comment' => '类型'])
            ->create();
        $user = $this->table('user');
        $user->addColumn('uuid', 'string', ['limit' => 36, 'comment' => 'UUID'])
            ->update();
        # 为现有用户生成UUID
        $userIds = $this->fetchAll('SELECT id FROM user');
        foreach ($userIds as $userId) {
            $id = $userId['id'];
            $uuid = Uuid::uuid4()->toString();
            $this->execute("UPDATE user SET uuid='$uuid' WHERE id=$id;");
        }
        # 设置UUID非空
        $this->table('user')->changeColumn('uuid', 'string', ['limit' => 36, 'null' => false, 'comment' => 'UUID'])
            ->update();
    }
}
