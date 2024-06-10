{include file="user/header"}

<title>未支付的金额</title>
<div class="page">
    <div class="page-wrapper">
        <div class="page-header d-print-none">
            <div class="container-xl">
                <div class="row g-2 align-items-center">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">未支付的金额</h3>
                        </div>
                        <div class="card-body">
                            {if empty($result)}
                                <div class="alert alert-important alert-success alert-dismissible" role="alert">
                                    <div class="d-flex">
                                        <div>
                                            <i class="fa-regular fa-circle-check"></i>
                                        </div>
                                        <div>
                                            没有需要支付的款项
                                        </div>
                                    </div>
                                </div>
                            {else}
                                <ul>
                                    {volist name="result" id="item"}
                                        <li>向 {$key} 支付￥ {$item}  </li>
                                    {/volist}
                                </ul>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="/footer"}