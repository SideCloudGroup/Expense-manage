{include file="admin/header"}

<title>最优支付</title>
<div class="page">
    <div class="page-wrapper">
        <div class="page-header d-print-none">
            <div class="container-xl">
                <div class="row g-2 align-items-center">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">最优支付</h3>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                {volist name="bestPayFinal" id="user" key="username1"}
                                    <div class="col-md-4 mb-3">
                                        <div class="card">

                                            <div class="card-header">
                                                <div>
                                                    <div class="row align-items-center">
                                                        <div class="col">
                                                            <div class="card-title">{$key}</div>
                                                            <div class="card-subtitle">
                                                                合计支出：￥ {$userStat[$key]['out']} |
                                                                未结收入：￥ {$userStat[$key]['in']}</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="card-body">
                                                <ul>
                                                    {volist name="user" id="item"}
                                                        <li>向 {$key} 支付￥ {$item}  </li>
                                                    {/volist}
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                {/volist}
                            </div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">原始数据</h3>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                {volist name="bestPayAll" id="user" key="username1"}
                                    <div class="col-md-4 mb-3">
                                        <div class="card">
                                            <div class="card-header">
                                                <h3 class="card-title">{$key}</h3>
                                            </div>
                                            <div class="card-body">
                                                <ul>
                                                    {volist name="user" id="item"}
                                                        <li>向 {$key} 支付￥ {$item}  </li>
                                                    {/volist}
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                {/volist}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="/footer"}