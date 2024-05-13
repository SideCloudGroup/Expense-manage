<?php
declare (strict_types=1);

namespace app\model;

use think\Model;

/**
 * @mixin Model
 * @property int $id
 * @property string $username
 * @property string $password
 */
class User extends Model
{
    protected $table = 'user';
    protected $pk = 'id';
}
