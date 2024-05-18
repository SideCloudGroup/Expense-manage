{include file="/user/header"}

<title>未支付的金额</title>
<div class="page">
    <div class="page-wrapper">
        <div class="page-header d-print-none">
            <div class="container-xl">
                <div class="row g-2 align-items-center">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">我需要支付的项目(按用户)</h3>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-transparent">
                                    <thead>
                                    <tr>
                                        <th>用户</th>
                                        <th>金额</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {volist name="results" id="result"}
                                        <tr>
                                            <td>{$result.username}</td>
                                            <td>{$result.totalPrice}</td>
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