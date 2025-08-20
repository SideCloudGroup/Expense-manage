{include file="/user/header"}
<title>{:getSetting('general_name')} - {$party.name} - 需支付的款项</title>

<div class="page">
    <div class="page-wrapper">
        <div class="container-xl">
            <div class="page-header d-print-none">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="page-title">{$party.name}</h2>
                        <div class="text-muted mt-1">您在该派对中需要支付的款项</div>
                    </div>
                    <div class="col-auto ms-auto d-print-none">
                        <div class="btn-list">
                            <a href="/user/payment" class="btn btn-secondary">
                                <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                                </svg>
                                返回列表
                            </a>
                            <a href="/user/party/{$party.id}" class="btn btn-primary">
                                <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                </svg>
                                查看派对详情
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row row-cards mt-2">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">待支付款项列表</h3>
                        </div>
                        <div class="card-body">
                            {if $items}
                                <div class="table-responsive">
                                    <table class="table table-vcenter">
                                        <thead>
                                        <tr>
                                            <th>描述</th>
                                            <th>金额</th>
                                            <th>发起人</th>
                                            <th>创建时间</th>
                                            <th>状态</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        {foreach $items as $item}
                                            <tr>
                                                <td>{$item.description}</td>
                                                <td class="text-danger">{$currencySymbol}{$item.amount}</td>
                                                <td>{$item.username}</td>
                                                <td>{$item.created_at}</td>
                                                <td>
                                                    <span class="text-muted">等待发起人确认</span>
                                                </td>
                                            </tr>
                                        {/foreach}
                                        </tbody>
                                    </table>
                                </div>
                                <div class="mt-3 p-3 bg-light rounded">
                                    <div class="row align-items-center">
                                        <div class="col">
                                            <div class="text-muted">总计未支付金额</div>
                                            <div class="h4 mb-0 text-danger">
                                                {$currencySymbol}{$totalAmount|default=0}
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <span class="text-muted small">付款后请联系发起人确认</span>
                                        </div>
                                    </div>
                                </div>
                            {else}
                                <div class="empty">
                                    <div class="empty-img">
                                        <svg class="icon icon-3xl" fill="none" stroke="currentColor"
                                             viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                        </svg>
                                    </div>
                                    <p class="empty-title">没有需要支付的款项</p>
                                    <p class="empty-subtitle text-muted">您在该派对中没有未支付的款项</p>
                                </div>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="/footer"}
