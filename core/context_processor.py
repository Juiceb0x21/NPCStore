def user_data(request):
    if 'user_data' in request.session:
        user_info = request.session['user_data']
        return {'user_data': user_info}
    
    return {}