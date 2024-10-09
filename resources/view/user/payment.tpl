{include file="/user/header"}

<title>{:env('APP.NAME')} - 需支付的项目</title>
<div class="page">
    <div class="page-wrapper">
        <div class="page-header d-print-none">
            <div class="container-xl">
                <div class="row g-2 align-items-center">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">需支付的项目</h3>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-transparent">
                                    <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>项目</th>
                                        <th>金额</th>
                                        <th>发起人</th>
                                        <th>创建时间</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {volist name="items" id="item"}
                                        <tr>
                                            <td>{$item.id}</td>
                                            <td>{$item.description}</td>
                                            <td>{$item.amount}</td>
                                            <td>{$item.username}</td>
                                            <td>{$item.created_at}</td>
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
</div>

{include file="/footer"}