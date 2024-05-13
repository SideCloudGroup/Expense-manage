<?php
declare (strict_types=1);

namespace app\command;

use app\model\User;
use think\console\Command;
use think\console\Input;
use think\console\input\Argument;
use think\console\Output;

class Register extends Command
{
    protected function configure()
    {
        // 指令配置
        $this->setName('register')
            ->addArgument('username', Argument::REQUIRED, 'Username')
            ->addArgument('password', Argument::REQUIRED, 'Password')
            ->setDescription('Register admin user');
    }

    protected function execute(Input $input, Output $output)
    {
        // 获取命令参数
        $username = $input->getArgument('username');
        $password = $input->getArgument('password');
        // 检测用户名是否已存在
        $user = User::where('username', $username)->find();
        if ($user) {
            $output->writeln('Username already exists');
        } else {
            $user = new User();
            $user->username = $username;
            $user->password = password_hash($password, PASSWORD_ARGON2ID);
            $user->admin = 1;
            $user->save();
            $output->writeln('Done');
        }
    }
}