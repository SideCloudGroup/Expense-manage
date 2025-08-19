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
                            <a class="btn btn-primary ms-3" href="/admin/total/download"
                               target="_blank">下载待支付记录</a>
                            <button class="btn btn-danger ms-2"
                                    hx-post="/admin/total/clear"
                                    hx-confirm="此操作会清空数据库中所有待支付记录，是否继续？"
                                    hx-swap="none"
                            >清空待支付记录
                            </button>
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
                                                                合计支出：{:getUnitSign()} {$userStat[$key]['out']} |
                                                                未结收入：{:getUnitSign()} {$userStat[$key]['in']}</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="card-body">
                                                <ul>
                                                    {volist name="user" id="item"}
                                                        <li>向 {$key} 支付{:getUnitSign()} {$item}  </li>
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
                                                        <li>向 {$key} 支付{:getUnitSign()} {$item}  </li>
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