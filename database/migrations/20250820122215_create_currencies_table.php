<?php
declare (strict_types=1);

use app\model\Currency;
use think\migration\Migrator;

class CreateCurrenciesTable extends Migrator
{
    public function change()
    {
        $table = $this->table('currencies', ['engine' => 'InnoDB', 'collation' => 'utf8mb4_unicode_ci']);

        $table->addColumn('code', 'string', ['limit' => 3, 'null' => false])
            ->addColumn('name', 'string', ['limit' => 50, 'null' => false])
            ->addColumn('name_en', 'string', ['limit' => 100, 'null' => true])
            ->addColumn('symbol', 'string', ['limit' => 10, 'null' => false])
            ->addColumn('decimal_places', 'integer', ['limit' => 1, 'default' => 2, 'null' => false])
            ->addColumn('is_default', 'boolean', ['default' => false, 'null' => false])
            ->addColumn('is_active', 'boolean', ['default' => true, 'null' => false])
            ->addColumn('created_at', 'timestamp', ['null' => true, 'default' => 'CURRENT_TIMESTAMP'])
            ->addColumn('updated_at', 'timestamp', ['null' => true, 'default' => 'CURRENT_TIMESTAMP', 'update' => 'CURRENT_TIMESTAMP'])
            ->addIndex(['code'], ['unique' => true])
            ->addIndex(['is_default'])
            ->addIndex(['is_active'])
            ->create();

        $currencies = [
            ['cny', '人民币', 'Chinese Yuan', '¥', 2, 1, 1], // 默认货币
            ['usd', '美元', 'US Dollar', '$', 2, 0, 1],
            ['eur', '欧元', 'Euro', '€', 2, 0, 1],
            ['gbp', '英镑', 'British Pound', '£', 2, 0, 1],
            ['jpy', '日元', 'Japanese Yen', '¥', 0, 0, 1],
            ['hkd', '港币', 'Hong Kong Dollar', 'HK$', 2, 0, 1],
            ['twd', '新台币', 'New Taiwan Dollar', 'NT$', 2, 0, 1],
            ['sgd', '新加坡元', 'Singapore Dollar', 'S$', 2, 0, 1],
        ];

        foreach ($currencies as $currency) {
            Currency::create([
                'code' => $currency[0],
                'name' => $currency[1],
                'name_en' => $currency[2],
                'symbol' => $currency[3],
                'decimal_places' => $currency[4],
                'is_default' => $currency[5],
                'is_active' => $currency[6],
            ]);
        }
    }
}
