{include file="user/header"}

<title>{:env('APP.NAME')} - 汇率列表</title>
<div class="page">
    <div class="page-wrapper">
        <div class="page-header d-print-none">
            <div class="container-xl">
                <div class="row g-2 align-items-center">
                    <div class="card">
                        <div class="card-header">
                            <div>
                                <h3 class="card-title">
                                    汇率列表
                                </h3>
                                <p class="card-subtitle">
                                    默认货币: {$baseCurrency}
                                </p>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-transparent">
                                    <thead>
                                    <tr>
                                        <th>货币</th>
                                        <th>单价</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {volist name="currencies" id="price" key="name"}
                                        <tr>
                                            <td>{$key}</td>
                                            <td>{$price}</td>
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