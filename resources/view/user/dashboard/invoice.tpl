{include file='/user/header'}

<title>{:getSetting('general_name')} - 总未支付款项</title>
<div class="page">
    <div class="page-wrapper">
        <div class="page-header d-print-none">
            <div class="container-xl">
                <div class="row g-2 align-items-center">
                    <div class="col">
                        <h2 class="page-title">总未支付款项</h2>
                        <div class="text-muted mt-1">查看所有派对中您需要支付的款项</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="page-body">
            <div class="container-xl">
                {if $groupedItems}
                    {foreach $groupedItems as $partyId => $partyData}
                        <div class="card mb-3">
                            <div class="card-header">
                                <h3 class="card-title">{$partyData.party_name}</h3>
                                <div class="card-actions">
                                    <span class="badge bg-danger text-danger-fg fs-6">
                                        总计未支付: {$currencySymbol}{$partyData.total_amount|default=0}
                                    </span>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-vcenter">
                                        <thead>
                                        <tr>
                                            <th>项目</th>
                                            <th>金额</th>
                                            <th>发起人</th>
                                            <th>创建时间</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        {foreach $partyData.items as $item}
                                            <tr>
                                                <td>{$item.description}</td>
                                                <td class="text-danger">{$currencySymbol}{$item.amount}</td>
                                                <td>{$item.username}</td>
                                                <td>{$item.created_at}</td>
                                            </tr>
                                        {/foreach}
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    {/foreach}
                {else}
                    <div class="card">
                        <div class="card-body text-center">
                            <div class="empty">
                                <div class="empty-img">
                                    <svg class="icon icon-3xl" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                </div>
                                <p class="empty-title">没有需要支付的款项</p>
                                <p class="empty-subtitle text-muted">您在所有派对中都没有未支付的款项</p>
                            </div>
                        </div>
                    </div>
                {/if}
            </div>
        </div>
    </div>
</div>

{include file="/footer"}