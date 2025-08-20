{include file="/admin/header"}
<title>{:getSetting('general_name')} - 货币管理</title>

<div class="page">
    <div class="page-wrapper">
        <div class="container-xl">
            <div class="page-header d-print-none">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="page-title">货币管理</h2>
                        <div class="text-muted mt-1">管理系统支持的货币类型</div>
                    </div>
                    <div class="col-auto ms-auto d-print-none">
                        <div class="btn-list">
                            <button type="button" class="btn btn-primary"
                                    hx-get="/admin/currency/add-form"
                                    hx-target="#currencyFormContainer"
                                    hx-swap="innerHTML">
                                <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M12 4v16m8-8H4"/>
                                </svg>
                                添加货币
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 表单容器 -->
            <div id="currencyFormContainer"></div>

            <div class="row row-cards">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">支持的货币列表</h3>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-vcenter card-table">
                                    <thead>
                                    <tr>
                                        <th>货币代码</th>
                                        <th>中文名称</th>
                                        <th>英文名称</th>
                                        <th>符号</th>
                                        <th>小数位数</th>
                                        <th>状态</th>
                                        <th>操作</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {foreach $currencies as $code => $currency}
                                        <tr>
                                            <td>
                                                <span class="badge bg-primary text-primary-fg">{$code|strtoupper}</span>
                                            </td>
                                            <td>{$currency.name}</td>
                                            <td>{$currency.name_en}</td>
                                            <td>
                                                <span class="text-muted">{$currency.symbol}</span>
                                            </td>
                                            <td>{$currency.decimal_places}</td>
                                            <td>
                                                {if $currency.is_default}
                                                    <span class="badge bg-success text-success-fg">默认</span>
                                                {elseif $currency.is_active}
                                                    <span class="badge bg-primary text-primary-fg">启用</span>
                                                {else}
                                                    <span class="badge bg-secondary text-secondary-fg">禁用</span>
                                                {/if}
                                            </td>
                                            <td>
                                                <div class="btn-list flex-nowrap">
                                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                                            hx-get="/admin/currency/edit-form?code={$code}"
                                                            hx-target="#currencyFormContainer"
                                                            hx-swap="innerHTML">
                                                        编辑
                                                    </button>
                                                    {if !$currency.is_default}
                                                        <button type="button" class="btn btn-sm btn-outline-danger"
                                                                hx-delete="/admin/currency/delete"
                                                                hx-vals="js:{code: '{$code}'}"
                                                                hx-confirm="确定要删除货币 {$currency.name} ({$code|strtoupper}) 吗？"
                                                                hx-target="body"
                                                                hx-swap="none">
                                                            删除
                                                        </button>
                                                    {else}
                                                        <span class="text-muted">默认货币</span>
                                                    {/if}
                                                </div>
                                            </td>
                                        </tr>
                                    {/foreach}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="/footer"}
