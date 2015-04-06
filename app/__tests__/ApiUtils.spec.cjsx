# @cjsx React.DOM
jest.dontMock '../cjsx/utils/ApiUtils.cjsx'
ApiUtils = require '../cjsx/utils/ApiUtils.cjsx'

describe 'ApiUtils', ->
  createString = (strLength) -> new Array(strLength + 1).join('x')

  describe 'truncate method', ->

    it 'should not truncate strings <= 140 characters', ->
        result = ApiUtils._truncate createString(120)
        expect(result.length).toBe 120

        result = ApiUtils._truncate createString(140)
        expect(result.length).toBe 140

    it 'should truncate string > 140 characters', ->
        result = ApiUtils._truncate createString(141)
        expect(result.length).toBe 140

        result = ApiUtils._truncate createString(250)
        expect(result.length).toBe 140

    it 'should truncate on the last word and add an elipsis', ->
      longString = createString(138)
      longString += ' string that take me over 140 chars'
      result = ApiUtils._truncate(longString).replace(' ...', '')

      expect(result.length).toBe 138

  describe 'linkMentions method', ->

    it 'should replace @mentions mid string with anchor tags', ->
      testString = 'hello @someone in the middle of the string'
      result = ApiUtils._linkMentions testString
      expect(result).toContain "<a href='https://github.com/someone'>"

    it 'should replace @mentions that are the first word in a string with anchor tags', ->
      testString = '@someone in the middle of the string'
      result = ApiUtils._linkMentions testString
      expect(result).toContain "<a href='https://github.com/someone'>"

    it 'should not replace @mentions that are in the middle of words', ->
      testString = 'someword@someoneads in the middle of the string'
      result = ApiUtils._linkMentions testString
      expect(result).not.toContain "<a href='https://github.com/someone'>"

    it 'should wrap the test string in a <span> tag', ->
      testString = 'hello @someone in the middle of the string'
      resultArray = ApiUtils._linkMentions(testString).split('')
      openTag = resultArray.slice(0,6).join('')
      closeTag = resultArray.slice(-7).join('')

      expect(openTag).toBe '<span>'
      expect(closeTag).toBe '</span>'

  describe 'transform method', ->

    it 'should replace all passed in objects "body" property with a new object', ->
      response = [{body: 'someVal1'}, {body: 'someVal2'}]
      result = ApiUtils._transform response

      expect(result[0].body.truncatedHtml).not.toBe undefined
      expect(result[0].body.html).not.toBe undefined
      expect(result[1].body.truncatedHtml).not.toBe undefined
      expect(result[1].body.html).not.toBe undefined
