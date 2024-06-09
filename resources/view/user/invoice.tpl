{include file='/user/header'}

<title>账单管理</title>
<div class="page">
    <div class="page-wrapper">
        <div class="page-header d-print-none">
            <div class="container-xl">
                <div class="row g-2 align-items-center">
                    <div class="col">
                        <h2 class="page-title">
                            你好喵，{$username}
                        </h2>
                    </div>
                </div>
            </div>
        </div>
        <div class="page-body">
            <div class="container-xl">
                <div class="card card-lg">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-transparent">
                                <thead>
                                <tr>
                                    <th class="text-center">ID</th>
                                    <th>项目</th>
                                    <th class="text-end">价格</th>
                                    <th class="text-end">发起用户</th>
                                    <th class="text-end">状态</th>
                                    <th class="text-end">创建时间</th>
                                </tr>
                                </thead>
                                {volist name="items" id="item"}
                                    <tr>
                                        <td class="text-center">{$item.id}</td>
                                        <td><p class="strong mb-1">{$item.description}</p></td>
                                        <td class="text-end">{$item.amount}</td>
                                        <td class="text-end">{$item.username}</td>
                                        {if $item.paid}
                                            <td class="text-end"><span
                                                        class="badge bg-green text-green-fg">已支付</span>
                                            </td>
                                        {else}
                                            <td class="text-end"><span class="badge bg-red text-red-fg">未支付</span>
                                            </td>
                                        {/if}
                                        <td class="text-end">{$item.created_at}</td>
                                    </tr>
                                {/volist}
                                <tr>
                                    <td colspan="5" class="strong text-end">未支付</td>
                                    <td class="text-end">￥ {$totalPriceUnpaid}</td>
                                </tr>
                                <tr>
                                    <td colspan="5" class="strong text-end">已支付</td>
                                    <td class="text-end">￥ {$totalPricePaid}</td>
                                </tr>
                                <tr>
                                    <td colspan="5" class="strong text-end">总计</td>
                                    <td class="text-end">￥ {$totalPrice}</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="/footer"}