<?php

use think\migration\Migrator;

class Setting extends Migrator
{
    public function up(): void
    {
        $setting = $this->table('setting');
        $setting->addColumn('key', 'string', ['null' => false])
            ->addColumn('value', 'text', ['null' => false])
            ->create();
        (new \app\model\Setting(['key' => 'general_enableRegister', 'value' => true]))->save();
        (new \app\model\Setting(['key' => 'general_name', 'value' => env('APP_NAME', '开派对咯')]))->save();
    }
}
