{include file="admin/header"}

<title>费用管理</title>
<div class="container" style="margin-top: 1%">
    <div class="card border-dark">
        <h2 class="card-header">管理面板</h2>
        <ul class="list-group">
            <li class="list-group-item">
                <b>未支付费用:</b> {:getUnitSign()} {$totalPriceUnpaid}
            </li>
            <li class="list-group-item">
                <b>已支付费用:</b> {:getUnitSign()} {$totalPricePaid}
            </li>
            <li class="list-group-item">
                <b>总费用:</b> {:getUnitSign()} {$totalPrice}
            </li>
        </ul>
    </div>
</div>

{include file="/footer"}