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
                                {volist name="users" id="user" key="username1"}
                                    <div class="col-md-4 mb-3">
                                        <div class="card">
                                            <div class="card-header">
                                                <h3 class="card-title">{$key}</h3>
                                            </div>
                                            <div class="card-body">
                                                {volist name="user" id="item"}
                                                {$item} => {$key}
                                                {/volist}
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