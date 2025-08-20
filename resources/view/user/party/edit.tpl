{include file="/user/header"}
<title>{:getSetting('general_name')} - 编辑派对</title>

<div class="page">
    <div class="page-wrapper">
        <div class="container-xl">
            <div class="page-header d-print-none">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="page-title">编辑派对</h2>
                        <div class="text-muted mt-1">修改派对的基本信息和货币设置</div>
                    </div>
                    <div class="col-auto ms-auto d-print-none">
                        <div class="btn-list">
                            <a href="/user/party/{$party.id}" class="btn btn-secondary">
                                <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                                </svg>
                                返回派对详情
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row row-cards">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">派对信息</h3>
                        </div>
                        <div class="card-body">
                            <form hx-post="/user/party/{$party.id}/update" hx-trigger="submit" hx-swap="none">
                                <div class="mb-3">
                                    <label class="form-label required">派对名称</label>
                                    <input type="text" class="form-control" name="name" value="{$party.name}" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">派对描述</label>
                                    <textarea class="form-control" name="description" rows="3"
                                              placeholder="派对描述（可选）">{$party.description}</textarea>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label required">时区设置</label>
                                    <input type="text" class="form-control" id="timezone" name="timezone"
                                           value="{$party.timezone}" placeholder="输入时区，如：Asia/Shanghai" required>
                                    <div class="form-hint">输入时区标识符，系统会自动验证</div>
                                    <div id="timezone-suggestions" class="mt-2" style="display: none;">
                                        <div class="list-group list-group-flush">
                                            <!-- 时区建议将在这里显示 -->
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label required">基础货币</label>
                                    <select class="form-select" name="base_currency" id="base_currency" required
                                            onchange="updateSupportedCurrencies()">
                                        {foreach $available_currencies as $currency_code => $currency}
                                            <option value="{$currency_code}"
                                                    {if $currency_code == $party.base_currency}selected{/if}>
                                                {$currency.name} ({$currency_code|strtoupper})
                                            </option>
                                        {/foreach}
                                    </select>
                                    <div class="form-hint">基础货币将作为派对的默认货币单位</div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">可选货币</label>
                                    <div class="form-hint mb-2">选择派对支持的其他货币（基础货币会自动包含且不可取消）
                                    </div>
                                    <div class="row">
                                        {foreach $available_currencies as $currency_code => $currency}
                                            <div class="col-md-6 mb-2">
                                                <label class="form-check">
                                                    <input type="checkbox" class="form-check-input"
                                                           name="supported_currencies[]" value="{$currency_code}"
                                                           {if $currency_code == $party.base_currency}checked
                                                           disabled{/if}
                                                            {:in_array($currency_code, $current_supported_currencies)?'checked':''}
                                                    >
                                                    <span class="form-check-label">
                                                        {$currency.name} ({$currency_code|strtoupper})
                                                    </span>
                                                </label>
                                            </div>
                                        {/foreach}
                                    </div>
                                </div>

                                <div class="form-footer">
                                    <button type="submit" class="btn btn-primary">
                                        <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M5 13l4 4L19 7"/>
                                        </svg>
                                        保存修改
                                    </button>
                                    <a href="/user/party/{$party.id}" class="btn btn-secondary">取消</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">当前设置</h3>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label">当前时区</label>
                                <div class="form-control-plaintext">{:formatTimezone($party.timezone)}</div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">当前基础货币</label>
                                <div class="form-control-plaintext">{$party.base_currency|strtoupper}</div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">当前支持的货币</label>
                                <div class="form-control-plaintext" id="current-currencies-display">
                                    <span class="text-muted">加载中...</span>
                                </div>
                            </div>


                        </div>
                    </div>

                    <div class="card mt-3">
                        <div class="card-header">
                            <h3 class="card-title">注意事项</h3>
                        </div>
                        <div class="card-body">
                            <div class="alert alert-info">
                                <div class="d-flex">
                                    <div class="flex-shrink-0">
                                        <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                        </svg>
                                    </div>
                                    <div class="flex-fill ms-3">
                                        <div class="font-weight-medium">货币设置说明</div>
                                        <div class="text-muted small mt-1">
                                            • 基础货币是派对的默认货币<br>
                                            • 可选货币允许成员使用其他货币记账<br>
                                            • 系统会自动计算汇率转换<br>
                                            • 修改货币设置不会影响已有的收款项
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let timezoneTimeout;

    // 页面加载完成后初始化
    document.addEventListener('DOMContentLoaded', function () {
        loadCurrentCurrencies();
    });

    // 加载当前支持的货币信息
    function loadCurrentCurrencies() {
        const supportedCurrencies = {$party.supported_currencies|raw};
        let currencies = [];

        if (supportedCurrencies) {
            try {
                currencies = JSON.parse(supportedCurrencies);
            } catch (e) {
                currencies = ['{$party.base_currency}'];
            }
        } else {
            currencies = ['{$party.base_currency}'];
        }

        if (currencies.length === 0) {
            document.getElementById('current-currencies-display').innerHTML = '{$party.base_currency|strtoupper}';
            return;
        }

        // 调用后端API获取货币名称
        fetch('/user/party/currency-info', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                currencies: currencies
            })
        })
            .then(response => response.json())
            .then(data => {
                if (data.ret === 1) {
                    const currencyNames = Object.values(data.currency_info);
                    document.getElementById('current-currencies-display').innerHTML = currencyNames.join(', ');
                } else {
                    // 失败时显示原始货币代码
                    document.getElementById('current-currencies-display').innerHTML = currencies.map(c => c.toUpperCase()).join(', ');
                }
            })
            .catch(error => {
                console.error('加载货币信息失败:', error);
                // 失败时显示原始货币代码
                document.getElementById('current-currencies-display').innerHTML = currencies.map(c => c.toUpperCase()).join(', ');
            });
    }

    // 时区输入处理
    document.getElementById('timezone').addEventListener('input', function (e) {
        const query = e.target.value.trim();

        clearTimeout(timezoneTimeout);

        if (query.length < 2) {
            document.getElementById('timezone-suggestions').style.display = 'none';
            return;
        }

        timezoneTimeout = setTimeout(() => {
            fetch(`/user/party/search-timezones?query=${encodeURIComponent(query)}`)
                .then(response => response.json())
                .then(data => {
                    if (data.ret === 1 && data.timezones.length > 0) {
                        showTimezoneSuggestions(data.timezones);
                    } else {
                        document.getElementById('timezone-suggestions').style.display = 'none';
                    }
                })
                .catch(error => {
                    console.error('搜索时区失败:', error);
                });
        }, 300);
    });

    function showTimezoneSuggestions(timezones) {
        const container = document.getElementById('timezone-suggestions');
        const suggestionsHtml = timezones.map(timezone =>
            `<div class="list-group-item list-group-item-action" 
                  style="cursor: pointer;" 
                  onclick="selectTimezone('${timezone}')">
                ${timezone}
            </div>`
        ).join('');

        container.innerHTML = suggestionsHtml;
        container.style.display = 'block';
    }

    function selectTimezone(timezone) {
        document.getElementById('timezone').value = timezone;
        document.getElementById('timezone-suggestions').style.display = 'none';
    }

    // 点击其他地方隐藏建议
    document.addEventListener('click', function (e) {
        if (!e.target.closest('#timezone')) {
            document.getElementById('timezone-suggestions').style.display = 'none';
        }
    });

    // 更新可选货币选择
    function updateSupportedCurrencies() {
        const baseCurrency = document.getElementById('base_currency').value;
        const checkboxes = document.querySelectorAll('input[name="supported_currencies[]"]');

        checkboxes.forEach(checkbox => {
            if (checkbox.value === baseCurrency) {
                checkbox.checked = true;
                checkbox.disabled = true;
            } else {
                checkbox.disabled = false;
            }
        });
    }

    // 页面加载完成后初始化货币选择
    document.addEventListener('DOMContentLoaded', function () {
        updateSupportedCurrencies();
    });
</script>

{include file="/footer"}
