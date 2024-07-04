{block name=accounts_table}
    {foreach from=$data item=row key=key}
        <table class="responsive-table" summary="{t 1=$data[$key]['main_account']['sn'][0] 2=$data[$key]['main_account']['givenName'][0]}User account: %1, %2{/t}" style="margin-top: 20px;">
        <thead>
            <tr>
                {if isset($data[$key]['aux_accounts'])}
                    <th colspan={2 + count($data[$key]['aux_accounts'])}>
                {else}
                    <th colspan="2">
                {/if}

                    {if $data[$key]['main_account']['_status'][0] === "not-found"}
                        {t 1=$data[$key]['main_account']['sn'][0] 2=$data[$key]['main_account']['givenName'][0]}New user account: %1, %2{/t}
                    {else}
                        {t 1=$data[$key]['main_account']['sn'][0] 2=$data[$key]['main_account']['givenName'][0]}User account: %1, %2{/t}
                    {/if}

                </th>
            </tr>
        </thead>

        <tbody>
        {if isset($data[$key]['aux_accounts'])}
            <tr>
                <td>
                    <table summary="{t 1=$data[$key]['main_account']['sn'][0] 2=$data[$key]['main_account']['givenName'][0]}Account group for %1, %2{/t}">
        {/if}

            {foreach from=$data[$key]['main_account'] item=value key=property}
                <tr>
                    <td>
                        <b>{$property}:</b>
                    </td>
                    <td>
                        {if ($property != "userPassword" && $property != "alias") || ( isset($data[$key]['main_account'][$property][0]) && $data[$key]['main_account'][$property][0]==="" )}
                            {$data[$key]['main_account'][$property][0]}
                        {elseif $property == "userPassword" && strpos($data[$key]['main_account']['_status'][0],"exists")!==FALSE }
                            {t}<keep>{/t}
                        {elseif strpos($data[$key]['main_account']['_status'][0],"data-incomplete")!==FALSE }
                        {elseif $property == "alias" }
                            {foreach from=$data[$key]['main_account']['alias'] item=alias key=idx}
                                {if "$idx" != "count" }
                                    {$alias}<br>
                                {/if}
                            {/foreach}
                        {else}
                            ************
                        {/if}
                    </td>
                </tr>
            {/foreach}

            {if $accounts_reviewed && $accounts_imported && !preg_match('/ignore/', $data[$key]['main_account']['_actions'][0])}
                <tr><td colspan="2"></td></tr>
                <tr>
                    <td>
                        <b>{t}Groups{/t}:</b>
                    </td>
                    <td>
                        <b>{t}Group membership actions{/t}:</b>
                    </td>
                </tr>
                {foreach $data[$key]['groups'] item=group key=idx_group}
                    {if in_array('posixGroup', $group['objectClass']) and in_array($group['cn'][0], array_keys($data[$key]['main_account']['_group_actions']))}
                        <tr>
                            <td>
                            {$group['cn'][0]}
                            </td>
                            <td>
                            {$data[$key]['main_account']['_group_actions'][$group['cn'][0]]}
                            </td>
                        </tr>
                    {elseif in_array('gosaGroupOfNames', $group['objectClass']) and in_array($group['cn'][0], array_keys($data[$key]['main_account']['_ogroup_actions']))}
                        <tr>
                            <td>
                                {$group['cn'][0]}
                            </td>
                            <td>
                                {$data[$key]['main_account']['_ogroup_actions'][$group['cn'][0]]}
                            </td>
                        </tr>
                    {/if}
                {/foreach}

                {if isset($data[$key]['optional_groups'])}
                    {foreach $data[$key]['optional_groups'] item=group key=idx_group}
                        {if (strpos($group['_status'][0], 'not-found')===FALSE) and in_array('posixGroup', $group['objectClass']) and in_array($group['cn'][0], array_keys($data[$key]['main_account']['_group_actions']))}
                            <tr>
                                <td>
                                    {$group['cn'][0]}
                                </td>
                                <td>
                                    {$data[$key]['main_account']['_group_actions'][$group['cn'][0]]}
                                </td>
                            </tr>
                        {elseif (strpos($group['_status'][0], 'not-found')===FALSE) and in_array('gosaGroupOfNames', $group['objectClass']) and in_array($group['cn'][0], array_keys($data[$key]['main_account']['_ogroup_actions']))}
                            <tr>
                                <td>
                                    {$group['cn'][0]}
                                </td>
                                <td>
                                    {$data[$key]['main_account']['_ogroup_actions'][$group['cn'][0]]}
                                </td>
                            </tr>
                        {/if}
                    {/foreach}
                {/if}
            {/if}

        {if isset($data[$key]['aux_accounts'])}
                    </table>
                </td>
            {foreach $data[$key]['aux_accounts'] item=aux_account key=idx_aux_account}
                    <td>
                        <table summary="{t 1=$aux_account['sn'][0] 2=$aux_account['givenName'][0]}User account: %1, %2{/t}">
                            <thead>
                                <tr>
                                    <th colspan="2">
                {if $aux_account['_status'][0] === "not-found"}
                                        {t 1=$aux_account['sn'][0] 2=$aux_account['givenName'][0]}New associated account: %1, %2{/t}
                {elseif $aux_account['_status'][0] === "data-incomplete"}
                                        {t 1=$aux_account['sn'][0] 2=$aux_account['givenName'][0]}Insufficient account data: %1, %2{/t}
                {else}
                                        {t 1=$aux_account['sn'][0] 2=$aux_account['givenName'][0]}Associated account: %1, %2{/t}
                {/if}
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                {foreach from=$aux_account item=value key=property}
                                <tr>
                                    <td>
                                        <b>{$property}:</b>
                                    </td>
                                    <td>
                {if $property != "userPassword" || ( isset ($aux_account[$property][0]) && $aux_account[$property][0]==="" )}
                                        {$aux_account[$property][0]}
                {elseif strpos($aux_account['_status'][0],"exists")!==FALSE }
                                        {t}<keep>{/t}
                {elseif strpos($aux_account['_status'][0],"data-incomplete")!==FALSE }
                {else}
                                        ************
                {/if}
                                    </td>
                                </tr>
                {/foreach}
            {if $accounts_reviewed and $accounts_imported}
            {if strpos($aux_account['_status'][0],"data-incomplete")===FALSE}
                            <tr><td colspan="2"></td></tr>
                            <tr>
                                <td>
                                <b>{t}Groups{/t}:</b>
                                </td>
                                <td>
                                <b>{t}Group membership actions{/t}:</b>
                                </td>
                            </tr>
            {foreach $data[$key]['aux_accounts_groups'] item=group key=idx_group}
            {if (strpos($group['_status'][0], 'not-found')===FALSE) and in_array('posixGroup', $group['objectClass']) and in_array($group['cn'][0], array_keys($aux_account['_group_actions'][$group['cn'][0]]))}
                            <tr>
                                <td>
                                {$group['cn'][0]}
                                </td>
                                <td>
                                {$aux_account['_group_actions'][$group['cn'][0]]}
                                </td>
                            </tr>
            {elseif (strpos($group['_status'][0], 'not-found')===FALSE) and in_array('gosaGroupOfNames', $group['objectClass']) and in_array($group['cn'][0], array_keys($aux_account['_ogroup_actions']))}
                            <tr>
                                <td>
                                {$group['cn'][0]}
                                </td>
                                <td>
                                {$aux_account['_ogroup_actions'][$group['cn'][0]]}
                                </td>
                            </tr>
            {/if}
            {/foreach}
            {/if}
            {/if}
                            </tbody>
                    </table>
                </td>
        {/foreach}
            </tr>
        {/if}
        </tbody>


        </table>
    {/foreach}
{/block}
