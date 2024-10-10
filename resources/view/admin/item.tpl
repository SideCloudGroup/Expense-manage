{include file="admin/header"}

<title>项目列表</title>
<div class="page">
    <div class="page-wrapper">
        <div class="page-header d-print-none">
            <div class="container-xl">
                <div class="row g-2 align-items-center">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">项目列表</h3>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-transparent">
                                    <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>支付人</th>
                                        <th>内容</th>
                                        <th>金额</th>
                                        <th>状态</th>
                                        <th>创建时间</th>
                                        <th>操作</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {volist name="items" id="item"}
                                        <tr>
                                            <td>{$item.id}</td>
                                            <td>{$item.username}</td>
                                            <td>{$item.description}</td>
                                            <td>{$item.amount}</td>
                                            <td>
                                                {if $item.paid}
                                                    <span class="badge bg-green text-green-fg btn"
                                                          hx-post="/admin/item/{$item.id}" hx-trigger="click"
                                                          hx-vals='{"paid": 0}'>已支付</span>
                                                {else}
                                                    <span class="badge bg-red text-red-fg btn"
                                                          hx-post="/admin/item/{$item.id}"
                                                          hx-trigger="click"
                                                          hx-vals='{"paid": 1}'>未支付</span>
                                                {/if}
                                            </td>
                                            <td>{$item.created_at}</td>
                                            <td>
                                                <button class="btn btn-danger"
                                                        hx-delete="/admin/item/{$item.id}"
                                                        hx-trigger="click"
                                                        hx-confirm="确定删除吗？"
                                                        hx-disabled-elt="button"
                                                >
                                                    删除
                                                </button>
                                            </td>
                                        </tr>
                                    {/volist}
                                    </tbody>
                                </table>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

{include file="/footer"}