{include file="admin/header"}

<title>系统设置</title>
<div class="page">
    <div class="page-wrapper">
        <div class="page-body">
            <div class="container-xl">
                <h1>系统设置</h1>
                <ul class="nav nav-tabs" id="myTab" role="tablist">
                    {volist name="categories" id="category"}
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="{$category}-tab" data-bs-toggle="tab"
                                    data-bs-target="#{$category}"
                                    type="button" role="tab" aria-controls="{$category}">
                                {$category}
                            </button>
                        </li>
                    {/volist}
                </ul>

                <form hx-post="/admin/setting" hx-target="#settings-container" hx-swap="none" hx-disabled-elt="button">
                    <div class="tab-content" id="settings-container">
                        {foreach $settings as $category => $items}
                            <div class="tab-pane fade" id="{$category}" role="tabpanel"
                                 aria-labelledby="{$category}-tab">
                                <div class="card mt-3">
                                    <div class="card-header">
                                        <h3 class="card-title">{$category}</h3>
                                    </div>
                                    <div class="card-body">
                                        {foreach $items as $item}
                                            <div class="mb-3 row">
                                                <label class="col col-form-label">{$item.name}</label>
                                                <div class="col">
                                                    {switch $item.type}
                                                    {case text}
                                                        <input class="form-control" name="{$item.key}" type="text"
                                                               value="{$settingData[$item.key]}">
                                                    {/case}
                                                    {case textarea}
                                                        <textarea class="form-control"
                                                                  name="{$item.key}">{$settingData[$item.key]}</textarea>
                                                    {/case}
                                                    {case switch}
                                                        <label class="form-check form-switch">
                                                            <input type="hidden" name="{$item.key}" value="0">
                                                            <input class="form-check-input" type="checkbox"
                                                                   name="{$item.key}"
                                                                   value="1"
                                                                   {if $settingData[$item.key]}checked{/if}>
                                                        </label>
                                                    {/case}
                                                    {case select}
                                                        <select class="form-select" name="{$item.key}">
                                                            {foreach $item.options as $optionKey => $optionValue}
                                                                <option value="{$optionKey}"
                                                                        {if $settingData[$item.key] == $optionKey}selected{/if}>{$optionValue}</option>
                                                            {/foreach}
                                                        </select>
                                                    {/case}
                                                    {/switch}
                                                    <small class="form-hint">{$item.description}</small>
                                                </div>
                                            </div>
                                        {/foreach}
                                    </div>
                                </div>
                            </div>
                        {/foreach}
                    </div>
                    <button class="btn btn-primary w-100 mt-3" type="submit">保存</button>
                </form>
            </div>
        </div>
    </div>
</div>
{include file="footer"}
<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.getElementById('general-tab').click();
    });
</script>