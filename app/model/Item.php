<?php
declare (strict_types=1);

namespace app\model;

use think\Model;

/**
 * @mixin Model
 * @property int $id
 * @property int userid
 * @property string $description
 * @property string $created_at
 * @property double $amount
 * @property bool $paid
 * @property int $initiator
 */
class Item extends Model
{
    protected $table = 'item';
    protected $pk = 'id';
}
