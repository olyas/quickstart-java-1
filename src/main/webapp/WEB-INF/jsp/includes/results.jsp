<%@include file="tags.jsp" %>
<c:set var="biasingProfileCount" value="${model.biasingProfileCount}"/>
<c:set var="width" value="${100/biasingProfileCount}"/>
<div id="scratchArea" style="display: none;"></div>
<table width="100%">
  <tr>

    <c:forEach begin="0" end="${biasingProfileCount -1}" varStatus="b">
    <c:set var="name" value="results${b.index}"/>
    <c:set var="results" value="${model[name]}"/>
    <td class="recordColumn recordColumn${b.index}" style="padding-right:2px;" valign="top" width="width:${width}%">

      <c:set var="index" value="${b.index}"/>
      <div class="columnSpecifics">
        <div class="columnControls">
          <c:if test="${b.index > 0}">
            <a href="javascript:;" onclick="removeColumn(${b.index});">delete</a>
          </c:if>
          <a href="javascript:;" onclick="addColumn(${b.index})">copy</a>
        </div>
        <a href="javascript:;" onclick="showColumnSpecifics()">Show Column Specifics >></a><br>
        <span class="error"><pre>${matchStrategyErrors[b.index]}</pre></span>
        <c:forEach items="${results.warnings}" var="warning">
          <span class="warnings"><pre>Warning: ${warning}</pre></span>
        </c:forEach>
        <%@include file="debug.jsp" %>

        <fieldset style="display:${cookie.showColumnSpecifics.value ? 'block' : 'none'}">
          <legend>Relevance &amp; Recall</legend>
          <input type="text" id="biasing${b.index}" class="biasingInput" value="${results.biasingProfile}" placeholder="Biasing Profile" style="width:220px;">
          <br>
          <%@include file="matchStrategy.jsp" %>
          <%@include file="sort.jsp" %>
          <%@include file="semantish.jsp" %>
          <%@include file="wildcard.jsp" %>
        </fieldset>
        <fieldset style="display:${cookie.showColumnSpecifics.value ? 'block' : 'none'}">
          <legend>Personalized Relevance</legend>
          <%@include file="sessionId.jsp" %>
        </fieldset>
      </div>

      <ol id="replacementRow${b.index}" style="display: none">

      </ol>


      <ol id="row${b.index}">
        <%@include file="record.jsp" %>
      </ol>

      </c:forEach>
    </td>
  </tr>
</table>
<script>

  $('.highlightCorresponding').hover(function () {
    var matchingRecords = $(this).attr('data-id').substring(5);
    $('.' + matchingRecords).addClass('highlight');
  }, function () {
    $('.highlightCorresponding').removeClass('highlight');
  });

  $('.strategyInput, .biasingInput, .sortInput, .sortDir').keyup(function (e) {
    var code = (e.keyCode ? e.keyCode : e.which);

    if (code == 13 && !$(this).hasClass('strategyInput')) {
      $('#form').submit();
      return;
    }
  });
  $('.sortInput, .sortDir').change(function (e) {
    for (var i = 1; i < 6; i++) {
      var sort = '';
      $('.sort' + i + 'Input').each(function () {
        sort += $(this).val() + "|"
      });
      sort = sort.substring(0, sort.length - 1);
      $('#colSort' + i).val(sort);

      var sort = '';
      $('.sort' + i + 'Dir').each(function () {
        sort += $(this).val() + "|"
      });
      sort = sort.substring(0, sort.length - 1);
      $('#colDir' + i).val(sort);
    }
    for (var i = 1; i < 6; i++) {
      $('#colSort' + i).trigger('change');
      $('#colDir' + i).trigger('change');
    }
  });

  $('.strategyInput').change(function (e) {
    var strategy = '';
    $('.strategyInput').each(function () {
      strategy += $(this).val() + "|"
    });
    strategy = strategy.substring(0, strategy.length - 1);
    $('#matchStrategy').val(strategy);
    $('#matchStrategy').trigger('change');
  });

  $('.sessionIdInput').change(function (e) {
    var sessionId = '';
    $('.sessionIdInput').each(function () {
      sessionId += $(this).val() + "|"
    });
    sessionId = sessionId.substring(0, sessionId.length - 1);
    $('#sessionId').val(sessionId);
    $('#sessionId').trigger('change');
  });

  $('.skipSemantishInput').change(function () {
    var skipSemantishes = '';
    $('.skipSemantishInput').each(function () {
      skipSemantishes += $(this).is(':checked') + ","
    });
    skipSemantishes = skipSemantishes.substring(0, skipSemantishes.length - 1);
    $('#skipSemantish').val(skipSemantishes);
    $('#skipSemantish').trigger('change');
  });

  $('.wildcardInput').change(function () {
    var wildcards = '';
    $('.wildcardInput').each(function () {
      wildcards += $(this).is(':checked') + ","
    });
    wildcards = wildcards.substring(0, wildcards.length - 1);
    $('#wildcard').val(wildcards);
    $('#wildcard').trigger('change');
  });

  $('.biasingInput').change(function (e) {
    var biasings = '';
    $('.biasingInput').each(function () {
      biasings += $(this).val() + ","
    });
    biasings = biasings.substring(0, biasings.length - 1);
    $('#biasingProfile').val(biasings);
    $('#biasingProfile').trigger('change');
  });

  function removeColumn(pIndex) {
    $('#biasing' + pIndex).remove();
    $('#matchStrategy' + pIndex).remove();
    $('.strategyInput, .biasingInput, .sortInput').trigger('change');
    generateHash();
    $('#form').submit();
  }
  function addColumn(pIndex) {
    var oldValue = $('#biasingProfile').val();
    var newValue = oldValue + ',' + $('#biasing' + pIndex).val();
    $('#biasingProfile').val(newValue);
    $('#biasingProfile').trigger('change');

    var oldValue = $('#matchStrategy').val();
    var newValue = oldValue + '|' + $('#strategy' + pIndex).val();
    $('#matchStrategy').val(newValue);
    $('#matchStrategy').trigger('change');

    generateHash();
    $('#form').submit();
  }
</script>